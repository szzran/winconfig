; Custom Komorebi Autohotkey

#Requires AutoHotkey v2.0
#SingleInstance Force
;#NoTrayIcon

; Initial tray settings
TraySetIcon("C:\Users\ishmat\Pictures\ICONs\watermelon (2).ico", 1, false)
A_IconTip := 'Komorebi Hotkey'

; Toggle suspend/unsuspend hotkey
#SuspendExempt true
^!p:: Suspend()
#SuspendExempt false

; App launch shortcut
!F2::
{
    Run("wt")
}
!F3:: ; Alt + F3 hotkey
{
    if WinExist("ahk_exe msedge.exe") ; Check if the window with msedge.exe is open
    {
        WinActivate("ahk_exe msedge.exe") ; Focus the window
    }
    else
    {
        Run("msedge") ; Launch the app if not running
    }
}

Komorebic(cmd) {
  RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; Komorebic specific command
!+o:: Komorebic("reload-configuration")

; Focus windows
!h:: Komorebic("focus left")
!j:: Komorebic("focus down")
!k:: Komorebic("focus up")
!l:: Komorebic("focus right")

!+[:: Komorebic("cycle-focus previous")
!+]:: Komorebic("cycle-focus next")

; Move windows
!+h:: Komorebic("move left")
!+j:: Komorebic("move down")
!+k:: Komorebic("move up")
!+l:: Komorebic("move right")

; Stack windows
!Left:: Komorebic("stack left")
!Down:: Komorebic("stack down")
!Up:: Komorebic("stack up")
!Right:: Komorebic("stack right")
!;:: Komorebic("unstack")
![:: Komorebic("cycle-stack previous")
!]:: Komorebic("cycle-stack next")

; Resize
!=:: Komorebic("resize-axis horizontal increase")
!-:: Komorebic("resize-axis horizontal decrease")
!+=:: Komorebic("resize-axis vertical increase")
!+_:: Komorebic("resize-axis vertical decrease")

; Manipulate windows
!t:: Komorebic("toggle-float")
!f:: Komorebic("toggle-monocle")
!q:: Komorebic("close")
!m:: Komorebic("minimize")

; Window manager options
!+r:: Komorebic("retile")
!p:: Komorebic("toggle-pause")
!s:: Komorebic("toggle-transparency")

; Layouts
!x:: Komorebic("flip-layout horizontal")
!y:: Komorebic("flip-layout vertical")
!v:: Komorebic("cycle-layout next")
!+v:: Komorebic("cycle-layout previous")

; Workspaces
!1:: Komorebic("focus-workspace 0")
!2:: Komorebic("focus-workspace 1")
!3:: Komorebic("focus-workspace 2")
!4:: Komorebic("focus-workspace 3")
!5:: Komorebic("focus-workspace 4")
!6:: Komorebic("focus-workspace 5")
!7:: Komorebic("focus-workspace 6")
!8:: Komorebic("focus-workspace 7")

; Move windows across workspaces
!+1:: Komorebic("move-to-workspace 0")
!+2:: Komorebic("move-to-workspace 1")
!+3:: Komorebic("move-to-workspace 2")
!+4:: Komorebic("move-to-workspace 3")
!+5:: Komorebic("move-to-workspace 4")
!+6:: Komorebic("move-to-workspace 5")
!+7:: Komorebic("move-to-workspace 6")
!+8:: Komorebic("move-to-workspace 7")