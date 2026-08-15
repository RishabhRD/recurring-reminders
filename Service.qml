import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  property var reminders: []
  property bool loading: false
  property string error: ""
  property string stdout: ""
  property string stderr: ""

  function helperPath() { return Qt.resolvedUrl("recurring-reminders").toString().replace(/^file:\/\//, "") }
  function run(args) {
    if (process.running) return
    stdout = ""; stderr = ""; error = ""; loading = true
    process.command = [helperPath()].concat(args)
    process.running = true
  }
  function refresh() { run(["list"]) }
  function add(title, minutes) { run(["add", String(minutes), title]) }
  function toggle(id) { run(["toggle", id]) }
  function remove(id) { run(["delete", id]) }
  function snooze(id, minutes) { run(["snooze", id, String(minutes)]) }
  function tick() { run(["tick"]) }

  Process {
    id: process
    stdout: SplitParser { onRead: data => root.stdout += data }
    stderr: SplitParser { onRead: data => root.stderr += data }
    onExited: function(code) {
      root.loading = false
      if (code !== 0) root.error = root.stderr || "Could not update reminders."
      else {
        try { root.reminders = JSON.parse(root.stdout || "[]") }
        catch (error) { root.error = "The reminder list could not be read." }
      }
    }
  }
  Timer { interval: 30000; running: true; repeat: true; triggeredOnStart: true; onTriggered: root.tick() }
}
