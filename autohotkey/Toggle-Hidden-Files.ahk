#Requires AutoHotkey v2.0

; Hotkey only works for the Explorer window and file picker.
#HotIf WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass") || WinActive("ahk_class #32770")
^h::
{
    global
    HiddenFiles_Status := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
    RegWrite(!HiddenFiles_Status, "REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
    Send("{f5}")
    Return
}
#HotIf