cmake_minimum_required(VERSION 3.16)

project(untitled7 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appuntitled7
    main.cpp
)

qt_add_qml_module(appuntitled7
    URI untitled7
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        PhoneBookAccess.h
        PhoneBookAccess.cpp
        QML_FILES
        QML_FILES CustomBtn.qml
        QML_FILES MyAddEditListData.qml
        QML_FILES MainListHeader.qml
        QML_FILES MainListDelegate.qml
)

qt_add_resources(appuntitled7 "android"
    PREFIX /
    FILES
    android/src/com/example/contactsdisplay/MainActivity.java

       android/AndroidManifest.xml
        android/build.gradle
        android/res/values/libs.xml
)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.

set_target_properties(appuntitled7 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appuntitled7
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)
target_link_libraries(appuntitled7
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appuntitled7
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
if(ANDROID)
set_property(TARGET Qt::Core APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
QT_ANDROID_EXPORTED_TARGET=appuntitled7) # Change "MyApp" to your target in set_target_properties()
set_property(TARGET Qt::Core APPEND PROPERTY INTERFACE_COMPILE_FEATURES
cxx_std_17)
endif()
