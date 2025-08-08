FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl unzip git libglib2.0-dev libgtk-3-dev liblzma-dev \
  build-essential wget \
  && rm -rf /var/lib/apt/lists/*

# Install rustup (default stable)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup default stable

# Install cargo-binstall
RUN cargo install cargo-binstall

# Install Tauri CLI and Dioxus CLI
RUN cargo binstall --no-confirm tauri-cli dioxus-cli --locked
