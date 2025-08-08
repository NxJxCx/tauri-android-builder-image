FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl unzip git libglib2.0-dev libgtk-3-dev liblzma-dev \
  build-essential openjdk-11-jdk wget \
  && rm -rf /var/lib/apt/lists/*

# Install rustup (default stable)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install cargo-binstall
RUN cargo install cargo-binstall

# Install Tauri CLI and Dioxus CLI
RUN cargo binstall --no-confirm tauri-cli dioxus-cli

# Install Android SDK and NDK
ENV ANDROID_HOME="/opt/android-sdk"
ENV NDK_VERSION="25.2.9519653"
ENV SDK_VERSION="8512546"

RUN mkdir -p $ANDROID_HOME/cmdline-tools && cd $ANDROID_HOME \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip \
    && unzip commandlinetools-linux-*.zip -d cmdline-tools \
    && mv cmdline-tools/cmdline-tools cmdline-tools/latest \
    && rm commandlinetools-linux-*.zip

ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$PATH"

# Accept licenses and install SDK/NDK
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" \
    "build-tools;33.0.2" "ndk;$NDK_VERSION"

ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV ANDROID_NDK_ROOT=$ANDROID_HOME/ndk/$NDK_VERSION
ENV NDK_HOME=$ANDROID_NDK_ROOT
ENV PATH="$ANDROID_NDK_ROOT:$PATH"
