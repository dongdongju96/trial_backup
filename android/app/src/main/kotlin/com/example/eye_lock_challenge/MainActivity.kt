package com.example.eye_lock_challenge

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.os.Handler
import android.os.Looper
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarker
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private lateinit var bridge: FaceLandmarkerBridge

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bridge = FaceLandmarkerBridge(this)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "eye_lock_challenge/face_landmarker"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> bridge.initialize(call.arguments, result)
                "detect" -> bridge.detect(call.arguments, result)
                "dispose" -> bridge.dispose(result)
                else -> result.notImplemented()
            }
        }
    }
}

private class FaceLandmarkerBridge(private val context: Context) {
    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var faceLandmarker: FaceLandmarker? = null

    fun initialize(arguments: Any?, result: MethodChannel.Result) {
        executor.execute {
            try {
                val args = arguments as? Map<*, *> ?: error("Missing initialize arguments.")
                val modelBytes = args["modelBytes"] as? ByteArray
                    ?: error("Missing face_landmarker.task bytes.")
                val modelBuffer = ByteBuffer.allocateDirect(modelBytes.size)
                modelBuffer.put(modelBytes)
                modelBuffer.rewind()

                val baseOptions = BaseOptions.builder()
                    .setModelAssetBuffer(modelBuffer)
                    .build()
                val options = FaceLandmarker.FaceLandmarkerOptions.builder()
                    .setBaseOptions(baseOptions)
                    .setRunningMode(RunningMode.VIDEO)
                    .setNumFaces(1)
                    .setMinFaceDetectionConfidence(floatArg(args, "minFaceDetectionConfidence", 0.55f))
                    .setMinFacePresenceConfidence(floatArg(args, "minFacePresenceConfidence", 0.55f))
                    .setMinTrackingConfidence(floatArg(args, "minTrackingConfidence", 0.55f))
                    .setOutputFaceBlendshapes(false)
                    .setOutputFacialTransformationMatrixes(false)
                    .build()

                faceLandmarker?.close()
                faceLandmarker = FaceLandmarker.createFromOptions(context, options)
                mainHandler.post { result.success(null) }
            } catch (error: Throwable) {
                mainHandler.post {
                    result.error("mediapipe_init_failed", error.message, null)
                }
            }
        }
    }

    fun detect(arguments: Any?, result: MethodChannel.Result) {
        executor.execute {
            try {
                val landmarker = faceLandmarker ?: error("Face Landmarker is not initialized.")
                val args = arguments as? Map<*, *> ?: error("Missing frame arguments.")
                val bitmap = bitmapFromFrame(args)
                val rotatedBitmap = rotateBitmap(bitmap, intArg(args, "sensorOrientation", 0))
                val mpImage = BitmapImageBuilder(rotatedBitmap).build()
                val timestampMs = longArg(args, "timestampMs", System.currentTimeMillis())
                val landmarkResult = landmarker.detectForVideo(mpImage, timestampMs)
                mainHandler.post { result.success(resultMap(landmarkResult.faceLandmarks())) }
            } catch (error: Throwable) {
                mainHandler.post {
                    result.error("mediapipe_detect_failed", error.message, null)
                }
            }
        }
    }

    fun dispose(result: MethodChannel.Result) {
        executor.execute {
            faceLandmarker?.close()
            faceLandmarker = null
            mainHandler.post { result.success(null) }
        }
    }

    private fun bitmapFromFrame(args: Map<*, *>): Bitmap {
        val format = args["format"] as? String ?: "unknown"
        if (format != "yuv420") {
            error("Unsupported Android camera format: $format")
        }

        val width = intArg(args, "width", 0)
        val height = intArg(args, "height", 0)
        val planes = args["planes"] as? List<*> ?: error("Missing image planes.")
        if (planes.size < 3) {
            error("YUV420 image requires 3 planes.")
        }

        val yPlane = planes[0] as? Map<*, *> ?: error("Missing Y plane.")
        val uPlane = planes[1] as? Map<*, *> ?: error("Missing U plane.")
        val vPlane = planes[2] as? Map<*, *> ?: error("Missing V plane.")
        val yBytes = yPlane["bytes"] as? ByteArray ?: error("Missing Y bytes.")
        val uBytes = uPlane["bytes"] as? ByteArray ?: error("Missing U bytes.")
        val vBytes = vPlane["bytes"] as? ByteArray ?: error("Missing V bytes.")
        val yRowStride = intArg(yPlane, "bytesPerRow", width)
        val uRowStride = intArg(uPlane, "bytesPerRow", width / 2)
        val vRowStride = intArg(vPlane, "bytesPerRow", width / 2)
        val uPixelStride = intArg(uPlane, "bytesPerPixel", 1)
        val vPixelStride = intArg(vPlane, "bytesPerPixel", 1)
        val pixels = IntArray(width * height)

        for (y in 0 until height) {
            val yRow = yRowStride * y
            val uvRow = y / 2
            for (x in 0 until width) {
                val uvColumn = x / 2
                val yValue = yBytes[yRow + x].toInt() and 0xff
                val uValue = uBytes[uRowStride * uvRow + uPixelStride * uvColumn].toInt() and 0xff
                val vValue = vBytes[vRowStride * uvRow + vPixelStride * uvColumn].toInt() and 0xff
                pixels[y * width + x] = yuvToArgb(yValue, uValue, vValue)
            }
        }

        return Bitmap.createBitmap(pixels, width, height, Bitmap.Config.ARGB_8888)
    }

    private fun rotateBitmap(bitmap: Bitmap, rotationDegrees: Int): Bitmap {
        val normalizedRotation = ((rotationDegrees % 360) + 360) % 360
        if (normalizedRotation == 0) {
            return bitmap
        }

        val matrix = Matrix()
        matrix.postRotate(normalizedRotation.toFloat())
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
    }

    private fun yuvToArgb(y: Int, u: Int, v: Int): Int {
        val yf = y.toFloat()
        val uf = u.toFloat() - 128f
        val vf = v.toFloat() - 128f
        val r = (yf + 1.402f * vf).toInt().coerceIn(0, 255)
        val g = (yf - 0.344136f * uf - 0.714136f * vf).toInt().coerceIn(0, 255)
        val b = (yf + 1.772f * uf).toInt().coerceIn(0, 255)
        return (0xff shl 24) or (r shl 16) or (g shl 8) or b
    }

    private fun resultMap(landmarksByFace: List<List<com.google.mediapipe.tasks.components.containers.NormalizedLandmark>>): Map<String, Any?> {
        if (landmarksByFace.isEmpty()) {
            return mapOf(
                "isFaceDetected" to false,
                "leftEyePoints" to emptyList<Map<String, Float>>(),
                "rightEyePoints" to emptyList<Map<String, Float>>(),
            )
        }

        val landmarks = landmarksByFace.first()
        return mapOf(
            "isFaceDetected" to true,
            "leftEyePoints" to points(landmarks, listOf(33, 133, 159, 145, 153, 154, 155)),
            "rightEyePoints" to points(landmarks, listOf(362, 263, 386, 374, 380, 381, 382)),
            "leftIrisCenter" to averagePoint(landmarks, listOf(468, 469, 470, 471, 472)),
            "rightIrisCenter" to averagePoint(landmarks, listOf(473, 474, 475, 476, 477)),
        )
    }

    private fun points(
        landmarks: List<com.google.mediapipe.tasks.components.containers.NormalizedLandmark>,
        indices: List<Int>
    ): List<Map<String, Float>> {
        return indices.filter { it < landmarks.size }.map { index ->
            point(landmarks[index].x(), landmarks[index].y())
        }
    }

    private fun averagePoint(
        landmarks: List<com.google.mediapipe.tasks.components.containers.NormalizedLandmark>,
        indices: List<Int>
    ): Map<String, Float>? {
        val valid = indices.filter { it < landmarks.size }
        if (valid.isEmpty()) {
            return null
        }

        val x = valid.sumOf { landmarks[it].x().toDouble() } / valid.size
        val y = valid.sumOf { landmarks[it].y().toDouble() } / valid.size
        return point(x.toFloat(), y.toFloat())
    }

    private fun point(x: Float, y: Float): Map<String, Float> {
        return mapOf("x" to x.coerceIn(0f, 1f), "y" to y.coerceIn(0f, 1f))
    }

    private fun intArg(args: Map<*, *>, key: String, defaultValue: Int): Int {
        return (args[key] as? Number)?.toInt() ?: defaultValue
    }

    private fun longArg(args: Map<*, *>, key: String, defaultValue: Long): Long {
        return (args[key] as? Number)?.toLong() ?: defaultValue
    }

    private fun floatArg(args: Map<*, *>, key: String, defaultValue: Float): Float {
        return (args[key] as? Number)?.toFloat() ?: defaultValue
    }
}
