import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "recurring-reminders"
  ipcTarget: "recurring-reminders"
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property color muted: Qt.darker(foreground, 1.55)
  readonly property int activeCount: reminderService.reminders.filter(function(item) { return item.enabled }).length

  function formatDue(seconds) {
    var remaining = Math.max(0, Math.round((Number(seconds) * 1000 - Date.now()) / 60000))
    if (remaining < 1) return "due now"
    if (remaining < 60) return "in " + remaining + "m"
    var hours = Math.floor(remaining / 60)
    return "in " + hours + "h " + (remaining % 60) + "m"
  }
  function repeatLabel(minutes) { return "Every " + minutes + " minute" + (minutes === 1 ? "" : "s") }
  function open() { reminderService.refresh(); controller.show(); Qt.callLater(function() { titleField.forceActiveFocus() }) }
  function close() { controller.hide() }
  function toggle() { opened ? close() : open() }
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Service { id: reminderService }
  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰀠"
    active: root.activeCount > 0
    tooltipText: root.activeCount > 0 ? root.activeCount + " recurring reminder" + (root.activeCount === 1 ? "" : "s") : "Recurring reminders"
    onPressed: function(buttonCode) { if (buttonCode === Qt.RightButton) reminderService.refresh(); else root.toggle() }
  }
  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    contentWidth: panel.fittedContentWidth(Style.space(430))
    contentHeight: panel.fittedContentHeight(content.implicitHeight, Style.space(620))
    Flickable {
      anchors.fill: parent
      contentWidth: width
      contentHeight: content.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick
      ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
      ColumnLayout {
        id: content
        width: parent.width
        spacing: Style.space(12)
        RowLayout {
          Layout.fillWidth: true
          Text { text: "RECURRING REMINDERS"; color: root.foreground; font.family: Style.font.family; font.bold: true; font.pixelSize: Style.font.heading }
          Item { Layout.fillWidth: true }
          Text { text: root.activeCount + " active"; color: root.muted; font.family: Style.font.family; font.pixelSize: Style.font.body }
        }
        Text { Layout.fillWidth: true; text: "Keep small habits on your radar. Reminders repeat until you pause or remove them."; wrapMode: Text.WordWrap; color: root.muted; font.family: Style.font.family; font.pixelSize: Style.font.body }
        Rectangle { Layout.fillWidth: true; height: 1; color: Qt.rgba(root.foreground.r, root.foreground.g, root.foreground.b, 0.16) }
        ColumnLayout {
          Layout.fillWidth: true; spacing: Style.space(7)
          Text { text: "NEW REMINDER"; color: root.muted; font.family: Style.font.family; font.bold: true; font.pixelSize: Style.font.bodySmall }
          TextField {
            id: titleField
            Layout.fillWidth: true
            placeholderText: "Drink water"
            onAccepted: addButton.clicked()
          }
          RowLayout {
            Layout.fillWidth: true
            Text { text: "Repeat every"; color: root.foreground; font.family: Style.font.family }
            SpinBox { id: minutesSpin; from: 1; to: 10080; value: 30; editable: true; Layout.preferredWidth: Style.space(92) }
            Text { text: "minutes"; color: root.muted; font.family: Style.font.family }
            Item { Layout.fillWidth: true }
            Button {
              id: addButton
              text: "Add reminder"
              enabled: titleField.text.trim().length > 0 && !reminderService.loading
              onClicked: { reminderService.add(titleField.text.trim(), minutesSpin.value); titleField.clear(); titleField.forceActiveFocus() }
            }
          }
        }
        Text { visible: reminderService.error !== ""; Layout.fillWidth: true; text: reminderService.error; color: Color.urgent; wrapMode: Text.WordWrap; font.family: Style.font.family }
        Repeater {
          model: reminderService.reminders
          delegate: Rectangle {
            required property var modelData
            Layout.fillWidth: true
            implicitHeight: card.implicitHeight + Style.space(20)
            radius: Style.radius(8)
            color: Qt.rgba(root.foreground.r, root.foreground.g, root.foreground.b, modelData.enabled ? 0.08 : 0.035)
            ColumnLayout {
              id: card
              anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: Style.space(10) }
              spacing: Style.space(6)
              RowLayout {
                Layout.fillWidth: true
                Text { Layout.fillWidth: true; text: modelData.title; color: modelData.enabled ? root.foreground : root.muted; font.family: Style.font.family; font.pixelSize: Style.font.title; elide: Text.ElideRight }
                Switch { checked: modelData.enabled; onToggled: reminderService.toggle(modelData.id) }
              }
              RowLayout {
                Layout.fillWidth: true
                Text { text: root.repeatLabel(Number(modelData.minutes)); color: root.muted; font.family: Style.font.family; font.pixelSize: Style.font.body }
                Text { text: "•"; color: root.muted }
                Text { text: modelData.enabled ? root.formatDue(modelData.nextDue) : "paused"; color: modelData.enabled ? root.foreground : root.muted; font.family: Style.font.family; font.pixelSize: Style.font.body }
                Item { Layout.fillWidth: true }
                Button { text: "Snooze 10m"; enabled: modelData.enabled; onClicked: reminderService.snooze(modelData.id, 10) }
                Button { text: "Remove"; onClicked: reminderService.remove(modelData.id) }
              }
            }
          }
        }
        Text { visible: !reminderService.loading && reminderService.reminders.length === 0; Layout.fillWidth: true; text: "No recurring reminders yet. Add one above to get started."; color: root.muted; horizontalAlignment: Text.AlignHCenter; font.family: Style.font.family; topPadding: Style.space(16); bottomPadding: Style.space(16) }
      }
    }
  }
}
