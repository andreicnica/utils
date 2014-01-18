#!/bin/bash
set -e # exit on any failing command

# Make sure you hava already copied the qt quick modules to the .app/Content/MacOS dir.
QTPATH=$1
APPPATH=$2
USAGE="USAGE: $0 path/to/qt path/to/appbundle"

if [ -z "$1" ] || [ -z "$2" ]; then
	echo $USAGE
	exit -1
fi

# Display params
echo "Changing references using the install_name_tool"
echo "==============================================="
echo "Params:"
echo "->Qt path: $QTPATH"
echo "->App path: $APPPATH"

# Print WARNING
echo ""
echo "========"
echo "WARNING"
echo "========"
echo "Make sure the qt path points to the directory which contains lib, plugins, bin, ..."
echo "Make sure that path/to/qt/qml/QtQuick contains the dynamic libraries!"
echo "Make sure that the app path points to the .app bundle of your app!"

# Wait for user input
read -p "Press any key to continue... "

# User wants to continue

echo "Copying QtQuick modules..."
cp -R $QTPATH/qml/QtQuick $APPPATH/Contents/MacOS
echo "Copying QtQuick modules...finished"

echo "Changing references..."

# Controls
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin.dylib
# Controls private
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin.dylib

# Dialogs
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin.dylib

# Layouts
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin.dylib

# LocalStorage 
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin.dylib

# Particles.2 
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin.dylib

# PrivateWidgets
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin.dylib

# Window 2
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin.dylib

# XmlListModel
install_name_tool -change $QTPATH/lib/QtCore.framework/Versions/5/QtCore @executable_path/../Frameworks/QtCore.framework/Versions/5/QtCore $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin.dylib
install_name_tool -change $QTPATH/lib/QtGui.framework/Versions/5/QtGui @executable_path/../Frameworks/QtGui.framework/Versions/5/QtGui $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin.dylib
install_name_tool -change $QTPATH/lib/QtWidgets.framework/Versions/5/QtWidgets @executable_path/../Frameworks/QtWidgets.framework/Versions/5/QtWidgets $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin.dylib
install_name_tool -change $QTPATH/lib/QtQuick.framework/Versions/5/QtQuick @executable_path/../Frameworks/QtQuick.framework/Versions/5/QtQuick $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin.dylib
install_name_tool -change $QTPATH/lib/QtQml.framework/Versions/5/QtQml @executable_path/../Frameworks/QtQml.framework/Versions/5/QtQml $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin.dylib
install_name_tool -change $QTPATH/lib/QtNetwork.framework/Versions/5/QtNetwork @executable_path/../Frameworks/QtNetwork.framework/Versions/5/QtNetwork $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin.dylib
echo "Changing references...finished"

echo "Removing debug libs..."
rm $APPPATH/Contents/MacOS/QtQuick/Controls/libqtquickcontrolsplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/Controls/Private/libqtquickcontrolsprivateplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/Dialogs/libdialogplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/Layouts/libqquicklayoutsplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/LocalStorage/libqmllocalstorageplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/Particles.2/libparticlesplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/PrivateWidgets/libwidgetsplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/Window.2/libwindowplugin_debug.dylib
rm $APPPATH/Contents/MacOS/QtQuick/XmlListModel/libqmlxmllistmodelplugin_debug.dylib
echo "Removing debug libs...finished"
echo "DONE."
