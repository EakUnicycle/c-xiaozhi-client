cmake_minimum_required(VERSION 3.21)

project(XiaozhiClient VERSION 1.0 LANGUAGES CXX)

# ตั้งค่าเป็น C++20 เพื่อให้รองรับมาตรฐานของ Qt 6.5+
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ป้องกันปัญหา Vulkan บน GitHub Actions
set(QT_NO_VULKAN TRUE)

# ค้นหาไฟล์ .cpp และ .h ทั้งหมดในโฟลเดอร์ src ให้อัตโนมัติ
file(GLOB_RECURSE SRC_FILES 
    "src/*.cpp" 
    "src/*.h"
)

# ค้นหาคอมโพเนนต์ของ Qt ที่จำเป็นสำหรับโปรเจกต์นี้
find_package(Qt6 REQUIRED COMPONENTS
    Quick
    Qml
    QuickControls2
    Network
    Multimedia
    Sql
    WebSockets
)

qt_standard_project_setup()

# สร้าง Executable โดยรวมไฟล์ source ทั้งหมด
qt_add_executable(XiaozhiClient
    src/main.cpp
    ${SRC_FILES}
)

# เพิ่ม QML Module และไฟล์ resource
qt_add_qml_module(XiaozhiClient
    URI Xiaozhi
    VERSION 1.0
    QML_FILES
        qml/main.qml
        qml/components/AboutDialog.qml
        qml/components/AddDeviceDialog.qml
        qml/components/ChatArea.qml
        qml/components/ChatBubble.qml
        qml/components/DeviceItem.qml
        qml/components/EditDeviceDialog.qml
        qml/components/MessageInput.qml
        qml/components/SettingsDialog.qml
        qml/components/SideBar.qml
        qml/components/TitleBar.qml
        qml/components/UpdateDialog.qml
        qml/theme/Theme.qml
)

# ระบุ Library ที่ต้องใช้เชื่อมต่อ
target_link_libraries(XiaozhiClient PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Network
    Qt6::Multimedia
    Qt6::Sql
    Qt6::WebSockets
)