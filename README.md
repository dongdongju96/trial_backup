# Eye Lock Challenge

Eye Lock Challenge is a Flutter cross-platform mobile game for Android and iOS.
The player chooses a mode, focuses on the highlighted eye area, and tries to
maintain eye contact as long as possible.

This MVP uses the front camera only for real-time processing. Camera frames are
not saved, recorded, or uploaded.

## Project Structure

```text
lib/
├── app.dart
├── main.dart
├── controllers/
├── data/
├── models/
├── screens/
├── services/
├── utils/
└── widgets/
```

## Real Device Testing

1. Install Flutter and confirm the setup:

   ```bash
   flutter doctor
   ```

2. Connect an Android phone or iPhone with developer mode enabled.

3. Confirm Flutter can see the device:

   ```bash
   flutter devices
   ```

4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Run on the connected device:

   ```bash
   flutter run
   ```

6. Grant camera permission when prompted.

7. Choose Male Mode or Female Mode and verify:

   - The countdown runs from 3 to 1.
   - The image reveals after countdown.
   - The timer starts.
   - The debug camera preview appears.
   - Mock gaze failure eventually ends the game.
   - The result screen shows the final time.

## Notes

- MediaPipe Face Landmarker integration is prepared behind
  `FaceLandmarkerService`, but the active implementation is still mock-based.
- Add the real model file at `assets/models/face_landmarker.task` before
  enabling the real MediaPipe service.
- Korean and English are supported through Flutter ARB localization files in
  `lib/l10n/`. Korean is used for Korean device locales, and English is used
  otherwise unless the user manually chooses a language in the app.
