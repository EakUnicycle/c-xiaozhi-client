cmake_minimum_required(VERSION 3.21)

project(XiaozhiClient VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Qml)

qt_standard_project_setup()

qt_add_executable(XiaozhiClient
    src/main.cpp
)

qt_add_qml_module(XiaozhiClient
    URI Xiaozhi
    VERSION 1.0
    QML_FILES
        qml/main.qml
)

target_link_libraries(XiaozhiClient
    PRIVATE Qt6::Quick Qt6::Qml
)