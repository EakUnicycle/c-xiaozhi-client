<div align="center">

# jtxiaozhi-client

</div>

<div align="center">

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS-lightgrey.svg)
![C++](https://img.shields.io/badge/C%2B%2B-20-blue.svg)
![Qt](https://img.shields.io/badge/Qt-6.9.2-green.svg)
![Version](https://img.shields.io/badge/Version-v0.1.0-red.svg)

A modern cross-platform audio communication client inspired by the xiaozhi-esp32 ecosystem.

[![YouTube](https://img.shields.io/badge/YouTube-jtserver-red.svg)](https://www.youtube.com/channel/UCu2whIFS3Ldw2G4DZ6596EA)
[![GitHub](https://img.shields.io/badge/GitHub-jwhna1-181717.svg)](https://github.com/jwhna1)

</div>

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Server Compatibility](#server-compatibility)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## Overview

### Interface Preview

#### Main Window Layout

<img width="1830" height="1080" alt="image" src="https://github.com/user-attachments/assets/1f72ce6f-8a50-45a4-8a2f-0c8acaaeba20" />

**jtxiaozhi-client** is a modern cross-platform audio communication client built with **C++**, **Qt**, and **QML**. It is designed for users who want to experience the xiaozhi ecosystem without requiring original ESP32 hardware.

Inspired by the xiaozhi-esp32 firmware ecosystem, this project provides a user-friendly graphical interface, flexible device management, and real-time audio communication capabilities.

### Design Goals

- **Modern UI** with a clean chat-style experience
- **Cross-platform support** for Windows and macOS
- **Dual protocol support** with MQTT + UDP and WebSocket
- **Real-time audio communication** with OPUS codec support
- **Multi-device management** for xiaozhi-compatible devices
- **Accessible user experience** for non-technical users
- **Free and open source** under the MIT License

---

## Features

### User Interface

- **Modern design** with a frameless window
- **Light and dark themes**
- **Chat-style interaction**, similar to modern messaging apps
- **Responsive layout** for different screen sizes

### Network Communication

- **Dual-protocol architecture**: MQTT + UDP and WebSocket
- **Automatic fallback switching** when one connection method fails
- **OTA-based configuration retrieval**
- **Isolated sessions** for multiple devices

### Audio Processing

- **OPUS codec support** with 8–48kHz sample rates and 60ms frames
- **Low-latency audio transmission and playback**
- **Audio cache and local file management**
- **Planned AEC support** based on WebRTC AudioProcessing AEC3

### Device Management

- **Multiple device support**
- **Graphical device add/edit/remove workflow**
- **Independent device sessions and chat history**
- **Real-time connection status display**

### Data Storage

- **SQLite-based persistence** for settings and chat history
- **Smart local cache** for audio and image files
- **Automatic configuration restore**

---

## Architecture

### Layered Design

```text
┌─────────────────────────────────────────┐
│              UI Layer (Qt Quick/QML)    │
│  • Main UI  • Theme System  • Interaction│
├─────────────────────────────────────────┤
│            Business Layer (C++)         │
│  • AppModel  • Device Mgmt  • Messaging  │
├─────────────────────────────────────────┤
│            Network Layer (C++)          │
│  • MQTT/UDP  • WebSocket  • OTA Config   │
├─────────────────────────────────────────┤
│             Audio Layer (C++)           │
│  • OPUS Codec  • AEC  • Audio Devices    │
├─────────────────────────────────────────┤
│            Storage Layer (C++)          │
│  • SQLite  • File Cache  • Config Mgmt   │
└─────────────────────────────────────────┘
```

### Core Tech Stack

- **Language**: C++20 + QML
- **GUI Framework**: Qt 6.9.2  
  (Core, Quick, QuickControls2, Network, Multimedia, Sql, WebSockets)
- **Audio**: OPUS codec, WebRTC AudioProcessing
- **Networking**: MQTT (Paho), WebSocket, UDP
- **Storage**: SQLite, JSON (nlohmann)
- **Build System**: CMake 3.26+, vcpkg
- **Security**: OpenSSL

### Project Structure

```text
jtxiaozhi-client/
├── src/                          # C++ source code
│   ├── main.cpp                  # Application entry
│   ├── models/                   # Data models
│   │   ├── AppModel.h/.cpp
│   │   └── ChatMessage.h
│   ├── network/                  # Network layer
│   │   ├── DeviceSession.h/.cpp
│   │   ├── MqttManager.h/.cpp
│   │   ├── UdpManager.h/.cpp
│   │   ├── WebSocketManager.h/.cpp
│   │   └── OtaManager.h/.cpp
│   ├── audio/                    # Audio layer
│   │   ├── AudioDevice.h/.cpp
│   │   ├── AudioDeviceManager.h/.cpp
│   │   ├── ConversationManager.h/.cpp
│   │   ├── OpusCodec.h/.cpp
│   │   └── AudioEncryptor.h/.cpp
│   ├── storage/                  # Storage layer
│   │   ├── AppDatabase.h/.cpp
│   │   ├── AudioCacheManager.h/.cpp
│   │   └── ImageCacheManager.h/.cpp
│   ├── utils/                    # Utilities
│   │   ├── Logger.h/.cpp
│   │   └── Config.h/.cpp
│   └── version/                  # Version info
│       └── version_info.h/.cpp
├── qml/                          # QML UI files
│   ├── main.qml
│   ├── components/
│   └── theme/
├── resources/
├── CMakeLists.txt
├── vcpkg.json
└── README.md
```

---

## System Requirements

### Minimum Requirements

- **Operating System**
  - Windows 10/11 (x64)
  - macOS 10.15+ (Intel / Apple Silicon)
- **Memory**: 4GB RAM minimum, 8GB recommended
- **Storage**: 500MB available disk space
- **Network**: Stable internet connection

### Development Requirements

- **Compiler**
  - MSVC 2022 (Windows)
  - Clang 15+ (macOS)
  - GCC 13+ (Linux, future support)
- **Qt**: 6.9.2 or later
- **CMake**: 3.26 or later
- **vcpkg**: latest version recommended

---

## Installation

### Prebuilt Releases (Recommended)

1. Download the release package from GitHub Releases:
   - Windows: `jtxiaozhi-client-v0.1.0-win64.exe`
   - macOS: `jtxiaozhi-client-v0.1.0-macos.dmg`

2. Install the application:
   - **Windows**: Run the `.exe` installer
   - **macOS**: Open the `.dmg` file and drag the app to `Applications`

3. Launch the application:
   - **Windows**: Start Menu → jtxiaozhi-client
   - **macOS**: Launchpad → jtxiaozhi-client

### Build from Source

#### Windows (MSVC 2022)

```bash
git clone https://github.com/jwhna1/jtxiaozhi-client.git
cd jtxiaozhi-client

vcpkg install

mkdir build
cd build
cmake .. -G "Ninja Multi-Config" -DCMAKE_TOOLCHAIN_FILE=[vcpkg-root]/scripts/buildsystems/vcpkg.cmake
cmake --build . --config Release

.\Release\jtxiaozhi-client.exe
```

#### macOS (Clang)

```bash
brew install qt@6

git clone https://github.com/jwhna1/jtxiaozhi-client.git
cd jtxiaozhi-client

vcpkg install

mkdir build
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=[vcpkg-root]/scripts/buildsystems/vcpkg.cmake
make -j$(sysctl -n hw.ncpu)

./jtxiaozhi-client
```

---

## Quick Start

### 1. First Launch

After starting the application, you will see:

- **Left sidebar**: device list and management
- **Center chat area**: conversation view
- **Bottom input area**: text and voice input

### 2. Add a xiaozhi Device

1. Click the **"+"** button in the sidebar
2. Fill in the device information:
   - **Device Name**
   - **OTA Server URL**
   - **MAC Address** (optional, can be generated automatically)
3. Click **Confirm** to save

### 3. Connect to a Device

You can double-click a device in the list or select it and connect manually.

The client will:

1. Retrieve OTA configuration automatically
2. Establish the MQTT connection
3. Request the UDP audio channel
4. Send a hello message and initialize the session

### 4. Start Interacting

Once connected, you can:

- Send **text messages**
- Use **voice input**
- Send **images** for recognition
- Test audio communication

---

## Usage

### Device Status

- **Offline**: device is not connected
- **Connecting**: connection in progress
- **Online**: device is connected and ready
- **In Conversation**: active voice communication in progress

### Device Management

- **Add device**: click the "+" button
- **Edit device**: right-click → Edit
- **Delete device**: right-click → Delete
- **Connect device**: double-click or use the connect action

### Message Types

- **Text messages**
- **Voice messages**
- **Image messages**
- **System messages** such as connection states and errors

### Audio Functions

- **Push-to-talk style recording**
- **Automatic playback** of received audio
- **Volume control**
- **Audio input/output device selection**

### Settings

#### General

- Light / dark theme
- Chinese / English interface
- Auto-connect to last device on startup

#### Network

- Enable WebSocket fallback
- Connection timeout
- Retry count

#### Audio

- Input device selection
- Output device selection
- Audio quality settings
- AEC toggle

---

## Server Compatibility

### Officially Supported / Targeted Servers

| Server Type | Support Status | Notes |
|------------|----------------|------|
| Official xiaozhi server | Full support | Recommended |
| xinnan-tech open-source server | Basic support | Open-source option |
| jtxiaozhi-server commercial edition | Enhanced support | Extended features |

### Other Compatible Servers

For other xiaozhi-compatible servers:

- **Protocol compatibility**: based on standard MQTT + UDP workflows
- **Basic support**: connection and text interaction
- **Test coverage**: not yet fully verified across all third-party servers
- **Feedback welcome**: please open an issue if you encounter compatibility problems

### Basic Server Requirements

- MQTT server with MQTT 3.1+ support
- UDP port for audio packets
- OTA configuration endpoint
- Optional WebSocket support

---

## Contributing

Contributions of all kinds are welcome.

### Ways to Contribute

#### Report Issues

- Use GitHub Issues to report bugs
- Include clear reproduction steps
- Provide logs, screenshots, and environment details where possible

#### Suggest Features

- Open an issue to describe your idea
- Explain the use case and expected behavior
- Discuss implementation details if relevant

#### Development Guidelines

- Use clear commit messages
- Keep each commit focused on one change
- Make sure the project builds successfully before submitting
- Include relevant tests when possible

### Development Setup

```bash
git clone https://github.com/jwhna1/jtxiaozhi-client.git
cd jtxiaozhi-client

vcpkg install qt6 opus nlohmann-json openssl paho-mqttpp3

mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build . --config Debug

.\Debug\jtxiaozhi-client.exe
```

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## Contact

### Free Software Statement

> This software is free to use. We do not charge users for access, installation, or normal usage. If someone claims to charge fees on behalf of this project, please be cautious and verify through the official channels below.

### Contact Information

| Type | Details |
|------|---------|
| Team | jtserver team |
| Email | jwhna1@gmail.com |
| Community | [Discord](https://discord.gg/HVV36XyA) |

### Social Links

| Platform | Link | Description |
|----------|------|-------------|
| GitHub | [github.com/jwhna1](https://github.com/jwhna1) | Source code |
| YouTube | [jtserver channel](https://www.youtube.com/channel/UCu2whIFS3Ldw2G4DZ6596EA) | Video demos and tutorials |
| Discord | [Join the community](https://discord.gg/HVV36XyA) | Community support and discussion |
| Project Page | [jtxiaozhi-client](https://github.com/jwhna1/jtxiaozhi-client) | Repository homepage |

### Get Involved

You can support the project by:

- Reporting bugs
- Suggesting improvements
- Improving documentation
- Contributing code
- Helping with translation
- Sharing the project with others

---

<div align="center">

**Thank you for using jtxiaozhi-client!**

If this project helps you, please consider giving it a Star.

Made with care by [jtserver team](https://github.com/jwhna1)

</div>
