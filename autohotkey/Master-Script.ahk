; MasterScript.ahk
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
#Persistent

; Set the tooltip text
Menu, Tray, Tip, Running Scripts:`n- Toggle-Hidden-Files.ahk`n- Switch-Opened-Windows.ahk
; Menu, Tray, Icon, C:\Users\ishmat\Pictures\ICONs\ControlKnobs.ico

; Include your individual scripts
#Include D:\Github\autohotkey\Toggle-Hidden-Files.ahk
#Include D:\Github\autohotkey\Switch-Opened-Windows.ahk

; Create a custom tray menu
Menu, Tray, Add, Reload, ReloadScript
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Default, ReloadScript
Menu, Tray, Click, 1

ReloadScript:
Reload
return

ExitScript:
ExitApp
return
