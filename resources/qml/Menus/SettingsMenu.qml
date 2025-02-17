//Copyright (c) 2020 Ultimaker B.V.
//Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 2.4

import UM 1.5 as UM
import Cura 1.0 as Cura

Cura.Menu
{
    id: base
    title: catalog.i18nc("@title:menu menubar:toplevel", "&Settings")

    PrinterMenu { }

    property var activeMachine: Cura.MachineManager.activeMachine
    Instantiator
    {
        id: extruderInstantiator
        model: activeMachine == null ? null : activeMachine.extruderList
        Cura.Menu
        {
            title: modelData.name
            property var extruder: (base.activeMachine === null) ? null : activeMachine.extruderList[model.index]
            NozzleMenu
            {
                title: Cura.MachineManager.activeDefinitionVariantsName
                shouldBeVisible: activeMachine.hasVariants
                extruderIndex: index
            }
            MaterialMenu
            {
                title: catalog.i18nc("@title:menu", "&Material")
                shouldBeVisible: activeMachine.hasMaterials
                extruderIndex: index
                updateModels: false
                onAboutToShow: updateModels = true
                onAboutToHide: updateModels = false
            }

            Cura.MenuSeparator
            {
                visible: Cura.MachineManager.activeMachine.hasVariants || Cura.MachineManager.activeMachine.hasMaterials
            }

            Cura.MenuItem
            {
                text: catalog.i18nc("@action:inmenu", "Set as Active Extruder")
                onTriggered: Cura.ExtruderManager.setActiveExtruderIndex(model.index)
            }

            Cura.MenuItem
            {
                text: catalog.i18nc("@action:inmenu", "Enable Extruder")
                onTriggered: Cura.MachineManager.setExtruderEnabled(model.index, true)
                visible: (extruder === null || extruder === undefined) ? false : !extruder.isEnabled
                height: visible ? implicitHeight: 0
            }

            Cura.MenuItem
            {
                text: catalog.i18nc("@action:inmenu", "Disable Extruder")
                onTriggered: Cura.MachineManager.setExtruderEnabled(index, false)
                visible: (extruder === null || extruder === undefined) ? false : extruder.isEnabled
                enabled: Cura.MachineManager.numberExtrudersEnabled > 1
                height: visible ? implicitHeight: 0
            }
        }
        onObjectAdded: function(index, object) {  base.insertMenu(index, object) }
        onObjectRemoved:function(object) {  base.removeMenu(object)}
    }

    Cura.MenuSeparator { }

    Cura.MenuItem { action: Cura.Actions.configureSettingVisibility }
}