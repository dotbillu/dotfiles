import QtQuick
import Quickshell
import Quickshell.Io 1.0

ShellRoot {
    Process {
        id: proc
        command: ["swaync-client", "-c"]
        running: true
        stdout: Process.Read
        onExited: {
            console.log(stdout)
            Qt.quit()
        }
    }
}
