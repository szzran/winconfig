#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}
;___________________________________________________________________________


;[--------------------[ Managing_Komorebi ]--------------------]

!F11::Komorebic("stop")
!F12::Komorebic("start")

!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")


;[--------------------[ Managing_windows ]---------------------]

!q::Komorebic("close")
!m::Komorebic("minimize")
!v::Komorebic("toggle-float")
!f::Komorebic("toggle-monocle")


;[----------------------[ Focus_windows ]----------------------]

!+a::Komorebic("focus left")
!+s::Komorebic("focus down")
!+w::Komorebic("focus up")
!+d::Komorebic("focus right")

!+[::Komorebic("cycle-focus previous")
!+]::Komorebic("cycle-focus next")


;[----------------------[ Move_windows ]-----------------------]

!^+a::Komorebic("move left")
!^+s::Komorebic("move down")
!^+w::Komorebic("move up")
!^+d::Komorebic("move right")


;[----------------------[ Stack_windows ]-----------------------]

!Left::Komorebic("stack left")
!Down::Komorebic("stack down")
!Up::Komorebic("stack up")
!Right::Komorebic("stack right")

!;::Komorebic("unstack")

![::Komorebic("cycle-stack previous")
!]::Komorebic("cycle-stack next")


;[-------------------------[ Resize ]---------------------------]

!h::Komorebic("resize-axis horizontal increase")
!g::Komorebic("resize-axis horizontal decrease")
!+h::Komorebic("resize-axis vertical increase")
!+g::Komorebic("resize-axis vertical decrease")


;[-------------------------[ Layouts ]--------------------------]

!t::Komorebic("flip-layout horizontal")
!y::Komorebic("flip-layout vertical")


;[-----------------------[ Workspaces ]-------------------------]

!1::Komorebic("focus-workspace 0")
!2::Komorebic("focus-workspace 1")
!3::Komorebic("focus-workspace 2")
!4::Komorebic("focus-workspace 3")
!5::Komorebic("focus-workspace 4")
!6::Komorebic("focus-workspace 5")
!7::Komorebic("focus-workspace 6")
!8::Komorebic("focus-workspace 7")

!a::Komorebic("cycle-workspace previous")
!s::Komorebic("cycle-workspace next")


;[-------------[ Move_windows_across_workspaces ]---------------]

!+1::Komorebic("move-to-workspace 0")
!+2::Komorebic("move-to-workspace 1")
!+3::Komorebic("move-to-workspace 2")
!+4::Komorebic("move-to-workspace 3")
!+5::Komorebic("move-to-workspace 4")
!+6::Komorebic("move-to-workspace 5")
!+7::Komorebic("move-to-workspace 6")
!+8::Komorebic("move-to-workspace 7")

!^a::Komorebic("cycle-move-to-workspace previous")
!^s::Komorebic("cycle-move-to-workspace next")


;[---------------------------[ Apps ]----------------------------]
