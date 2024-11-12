#Requires AutoHotkey v2.0
#SingleInstance Force
;#NoTrayIcon

; Toggle suspend/unsuspend all autohotkey instance
#SuspendExempt true
^!t::ToggleSuspendAll()
#SuspendExempt false

ToggleSuspendAll() {
    oldSetting := DetectHiddenWindows(true)
    for hwnd in WinGetList("ahk_class AutoHotkey") {
        ; 0x111 = WM_COMMAND, 65404 = ID_FILE_SUSPEND
        PostMessage(0x111, 65404,,, hwnd)
    }
    DetectHiddenWindows(oldSetting)
}