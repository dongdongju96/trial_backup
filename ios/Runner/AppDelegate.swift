import Flutter
import MediaPipeTasksVision
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let faceLandmarkerBridge = FaceLandmarkerBridge()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "eye_lock_challenge/face_landmarker",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [faceLandmarkerBridge] call, result in
      switch call.method {
      case "initialize":
        faceLandmarkerBridge.initialize(arguments: call.arguments, result: result)
      case "detect":
        faceLandmarkerBridge.detect(arguments: call.arguments, result: result)
      case "dispose":
        faceLandmarkerBridge.dispose(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private final class FaceLandmarkerBridge {
  private let queue = DispatchQueue(label: "eye_lock_challenge.face_landmarker")
  private var faceLandmarker: FaceLandmarker?
  private var modelPath: String?

  func initialize(arguments: Any?, result: @escaping FlutterResult) {
    queue.async {
      do {
        guard let args = arguments as? [String: Any],
              let modelBytes = args["modelBytes"] as? FlutterStandardTypedData else {
          throw BridgeError.invalidArguments("Missing face_landmarker.task bytes.")
        }

        let modelURL = FileManager.default.temporaryDirectory
          .appendingPathComponent("face_landmarker.task")
        try modelBytes.data.write(to: modelURL, options: .atomic)

        let options = FaceLandmarkerOptions()
        options.baseOptions.modelAssetPath = modelURL.path
        options.runningMode = .video
        options.numFaces = 1
        options.minFaceDetectionConfidence = args.floatValue(
          "minFaceDetectionConfidence",
          defaultValue: 0.55
        )
        options.minFacePresenceConfidence = args.floatValue(
          "minFacePresenceConfidence",
          defaultValue: 0.55
        )
        options.minTrackingConfidence = args.floatValue(
          "minTrackingConfidence",
          defaultValue: 0.55
        )
        options.outputFaceBlendshapes = false
        options.outputFacialTransformationMatrixes = false

        self.faceLandmarker = try FaceLandmarker(options: options)
        self.modelPath = modelURL.path
        DispatchQueue.main.async { result(nil) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(
            code: "mediapipe_init_failed",
            message: error.localizedDescription,
            details: nil
          ))
        }
      }
    }
  }

  func detect(arguments: Any?, result: @escaping FlutterResult) {
    queue.async {
      do {
        guard let faceLandmarker = self.faceLandmarker else {
          throw BridgeError.invalidArguments("Face Landmarker is not initialized.")
        }
        guard let args = arguments as? [String: Any] else {
          throw BridgeError.invalidArguments("Missing frame arguments.")
        }

        let image = try self.mpImage(from: args)
        let timestamp = args.intValue(
          "timestampMs",
          defaultValue: Int(Date().timeIntervalSince1970 * 1000)
        )
        let landmarkResult = try faceLandmarker.detect(
          videoFrame: image,
          timestampInMilliseconds: timestamp
        )
        DispatchQueue.main.async {
          result(self.resultMap(landmarkResult.faceLandmarks))
        }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(
            code: "mediapipe_detect_failed",
            message: error.localizedDescription,
            details: nil
          ))
        }
      }
    }
  }

  func dispose(result: @escaping FlutterResult) {
    queue.async {
      self.faceLandmarker = nil
      self.modelPath = nil
      DispatchQueue.main.async { result(nil) }
    }
  }

  private func mpImage(from args: [String: Any]) throws -> MPImage {
    guard args["format"] as? String == "bgra8888" else {
      throw BridgeError.invalidArguments("Unsupported iOS camera format.")
    }
    guard let planes = args["planes"] as? [[String: Any]],
          let firstPlane = planes.first,
          let bytes = firstPlane["bytes"] as? FlutterStandardTypedData else {
      throw BridgeError.invalidArguments("Missing BGRA image plane.")
    }

    let width = args.intValue("width", defaultValue: 0)
    let height = args.intValue("height", defaultValue: 0)
    let bytesPerRow = firstPlane.intValue("bytesPerRow", defaultValue: width * 4)
    guard width > 0, height > 0 else {
      throw BridgeError.invalidArguments("Invalid frame size.")
    }
    guard let provider = CGDataProvider(data: bytes.data as CFData) else {
      throw BridgeError.invalidArguments("Could not create image provider.")
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo.byteOrder32Little.union(
      CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    )
    guard let cgImage = CGImage(
      width: width,
      height: height,
      bitsPerComponent: 8,
      bitsPerPixel: 32,
      bytesPerRow: bytesPerRow,
      space: colorSpace,
      bitmapInfo: bitmapInfo,
      provider: provider,
      decode: nil,
      shouldInterpolate: false,
      intent: .defaultIntent
    ) else {
      throw BridgeError.invalidArguments("Could not create CGImage.")
    }

    let orientation = imageOrientation(
      sensorOrientation: args.intValue("sensorOrientation", defaultValue: 0)
    )
    let uiImage = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    return try MPImage(uiImage: uiImage)
  }

  private func imageOrientation(sensorOrientation: Int) -> UIImage.Orientation {
    switch ((sensorOrientation % 360) + 360) % 360 {
    case 90:
      return .right
    case 180:
      return .down
    case 270:
      return .left
    default:
      return .up
    }
  }

  private func resultMap(_ landmarksByFace: [[NormalizedLandmark]]) -> [String: Any] {
    guard let landmarks = landmarksByFace.first else {
      return [
        "isFaceDetected": false,
        "leftEyePoints": [],
        "rightEyePoints": [],
      ]
    }

    return [
      "isFaceDetected": true,
      "leftEyePoints": points(landmarks, indices: [33, 133, 159, 145, 153, 154, 155]),
      "rightEyePoints": points(landmarks, indices: [362, 263, 386, 374, 380, 381, 382]),
      "leftIrisCenter": averagePoint(landmarks, indices: [468, 469, 470, 471, 472]) as Any,
      "rightIrisCenter": averagePoint(landmarks, indices: [473, 474, 475, 476, 477]) as Any,
    ]
  }

  private func points(_ landmarks: [NormalizedLandmark], indices: [Int]) -> [[String: Float]] {
    indices.compactMap { index in
      guard index < landmarks.count else {
        return nil
      }
      return point(x: landmarks[index].x, y: landmarks[index].y)
    }
  }

  private func averagePoint(
    _ landmarks: [NormalizedLandmark],
    indices: [Int]
  ) -> [String: Float]? {
    let validIndices = indices.filter { $0 < landmarks.count }
    guard !validIndices.isEmpty else {
      return nil
    }

    let x = validIndices.reduce(Float(0)) { $0 + landmarks[$1].x } / Float(validIndices.count)
    let y = validIndices.reduce(Float(0)) { $0 + landmarks[$1].y } / Float(validIndices.count)
    return point(x: x, y: y)
  }

  private func point(x: Float, y: Float) -> [String: Float] {
    [
      "x": min(max(x, 0), 1),
      "y": min(max(y, 0), 1),
    ]
  }
}

private enum BridgeError: LocalizedError {
  case invalidArguments(String)

  var errorDescription: String? {
    switch self {
    case .invalidArguments(let message):
      return message
    }
  }
}

private extension Dictionary where Key == String, Value == Any {
  func intValue(_ key: String, defaultValue: Int) -> Int {
    if let value = self[key] as? NSNumber {
      return value.intValue
    }
    if let value = self[key] as? Int {
      return value
    }
    return defaultValue
  }

  func floatValue(_ key: String, defaultValue: Float) -> Float {
    if let value = self[key] as? NSNumber {
      return value.floatValue
    }
    if let value = self[key] as? Float {
      return value
    }
    if let value = self[key] as? Double {
      return Float(value)
    }
    return defaultValue
  }
}
