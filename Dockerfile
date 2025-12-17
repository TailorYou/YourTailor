# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install System Tools (Cached unless this list changes)
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget \
    && rm -rf /var/lib/apt/lists/*

# 2. Setup Android SDK (Cached)
ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
ENV ANDROID_HOME="/usr/local/android-sdk"
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -L ${SDK_URL} -o cmdline-tools.zip \
    && unzip cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm cmdline-tools.zip

ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"
RUN yes | sdkmanager --licenses

# 3. Install Flutter (Cached)
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="${PATH}:/usr/local/flutter/bin"
RUN flutter doctor

WORKDIR /app

# 4. Get Flutter Dependencies (Make them permanent in the image)
COPY pubspec.yaml pubspec.lock ./
# We remove the --mount here so the plugins stay inside the image
RUN flutter pub get

# 5. Cache Android/Gradle Dependencies
COPY android/gradlew ./android/
COPY android/gradle/wrapper/ ./android/gradle/wrapper/
COPY android/build.gradle android/settings.gradle ./android/
COPY android/app/build.gradle ./android/app/

RUN echo "sdk.dir=/usr/local/android-sdk" > android/local.properties && \
    echo "flutter.sdk=/usr/local/flutter" >> android/local.properties

RUN chmod +x android/gradlew

# Now Gradle will find the plugins because they are part of the image
RUN --mount=type=cache,target=/root/.gradle \
    cd android && ./gradlew tasks --no-daemon

# 6. Copy the rest of the code
COPY . .

# 7. Final Build
CMD ["flutter", "build", "apk", "--release", "--split-per-abi"]
