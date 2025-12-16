# yourtailor

# Flutter + Docker: Build & Run Guide

This project uses **Docker to build Flutter apps**, not to run Android UI.

---

## What Docker is used for

✅ Build APK / AAB reliably
✅ CI/CD friendly builds
✅ Same environment for all teammates

❌ NOT for running Android UI or emulator

---

## Prerequisites (Host Machine)

* Docker Desktop installed
* (Optional) Android SDK + emulator OR Android phone (for installing APK)
* (Optional) Flutter installed locally (for development & testing)

---

## 1. Build the Docker image

From the project root:

```bash
docker build -t flutter-app .
```

---

## 2. Verify build output inside Docker

```bash
docker run -it flutter-app bash
```

Inside container:

```bash
ls build/app/outputs/flutter-apk
```

Expected output:

```
app-arm64-v8a-release.apk
app-armeabi-v7a-release.apk
app-x86_64-release.apk
```

---

## 3. Copy APK from Docker to host

### Option A: Copy from container (recommended)

```bash
docker run --name flutter_tmp flutter-app
docker cp flutter_tmp:/app/build/app/outputs/flutter-apk ./apk
docker rm flutter_tmp
```

APK files will appear in:

```
./apk/
```

---

## 4. Install APK on device or emulator

### Android emulator / phone (ADB)

```bash
adb install apk/app-arm64-v8a-release.apk
```

### Physical phone

1. Copy APK to phone
2. Enable **Install unknown apps**
3. Tap APK → Install

---

## 5. Running Flutter locally (recommended for development)

Docker is for **building**, not UI testing.

```bash
flutter pub get
flutter run
```

---

## 6. Flutter Web (can run in Docker)

```bash
flutter build web
```

Run server:

```bash
docker run -p 8080:8080 flutter-app \
  bash -c "cd build/web && python3 -m http.server 8080"
```

Open browser:

```
http://localhost:8080
```

---

## Common Mistakes

❌ `flutter run` inside Docker (won’t work)
❌ Expecting Android UI from container
❌ Forgetting to copy APK out

---

## TL;DR

| Goal           | Use          |
| -------------- | ------------ |
| Build APK      | Docker       |
| Run Android UI | Host machine |
| CI/CD          | Docker       |
| Web preview    | Docker       |

---

Maintained for team use ✅

