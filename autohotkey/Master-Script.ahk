﻿#Requires AutoHotkey v2.0
#SingleInstance force

SendMode("Input")
SetWorkingDir(A_ScriptDir)
Persistent

; Set the tooltip text
A_IconTip := (
    "Running Scripts:`n"
    "- Toggle-Hidden-Files (ctrl+h)`n"
    "- Switch-Opened-Windows (alt+~)`n"
    "- FullScreen-Current-Window (alt+shift+f)"
)

; Included individual scripts
#Include "Toggle-Hidden-Files.ahk"
#Include "Switch-Opened-Windows.ahk"
#Include "FullScreen-Current-Window.ahk"