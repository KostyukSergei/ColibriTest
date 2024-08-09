# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.16)
project(calqlatr LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(calqlatrexample WIN32 MACOSX_BUNDLE
    main.cpp
)

target_link_libraries(calqlatrexample PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

qt_add_qml_module(calqlatrexample
    URI demos.calqlatr
    VERSION 1.0
    QML_FILES
        "Main.qml"
        "content/Display.qml"
        "content/NumberPad.qml"
        "content/CalculatorButton.qml"

        "content/calculator.js"
    RESOURCES
        "content/fonts/OpenSans-SemiBold.ttf"
)
if(ANDROID)
    set_target_properties(cal


        QML_FILES content/secretMenu.qml
        RESOURCES fonts.qrc
        RESOURCES res.qrc
        RESOURCES content/fonts.qrc
        RESOURCES content/fonts.qrc
RESOURCES content/fonts/OpenSans-SemiBold.ttf content/fonts.qrc
QML_FILES content/calculator.js content/CalculatorButton.qml content/Display.qml content/NumberPad.qml        RESOURCES content/fonts.qrc       RESOURCES content/fonts.qrc
        RESOURCES content/fonts.qrc
RESOURCES content/fonts/OpenSans-SemiBold.ttf
QML_FILES content/calculator.js content/CalculatorButton.qml content/Display.qml content/NumberPad.qml
        RESOURCES content/fonts/OpenSans-SemiBold.ttf
        RESOURCES OpenSans-SemiBold.ttf
        RESOURCES content/OpenSans-SemiBold.ttf
        RESOURCES content/OpenSans-SemiBold.ttf
        RESOURCES content/OpenSans-SemiBold.ttfqlatrexample
                         PROPERTIES
                            QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
                            QT_ANDROID_TARGET_SDK_VERSION "33")
endif()
if(IOS)
    set(asset_catalog_path "ios/Assets.xcassets")
    target_sources(calqlatrexample PRIVATE "${asset_catalog_path}")
    set_source_files_properties(${asset_catalog_path} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
    set_target_properties(calqlatrexample
        PROPERTIES XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME AppIcon)
endif()

install(TARGETS calqlatrexample
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET calqlatrexample
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
