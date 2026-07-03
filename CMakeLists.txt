cmake_minimum_required(VERSION 3.26)

project(XiaozhiClient VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ค้นหาไฟล์ source อัตโนมัติ
file(GLOB_RECURSE SRC_FILES "src/*.cpp" "src/*.h")

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

qt_add_executable(XiaozhiClient
    src/main.cpp
    ${SRC_FILES}
)

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

target_link_libraries(XiaozhiClient PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Network
    Qt6::Multimedia
    Qt6::Sql
    Qt6::WebSockets
)