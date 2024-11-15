#Requires AutoHotkey v2.0

^+.::CheckActiveWindow()

CheckActiveWindow()
{
global
  ID := WinExist("A")
  windowClass := WinGetClass("ahk_id " ID)
  WClasses := "CabinetWClass ExploreWClass"
  if InStr(WClasses, windowClass)
    Toggle_HiddenFiles_Display()
Return
}

Toggle_HiddenFiles_Display()
{
global
  RegPath := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

  HiddenFiles_Status := RegRead(RegPath, "Hidden")

  if (HiddenFiles_Status = 2)
      RegWrite(1, "REG_DWORD", RegPath, "Hidden")
  else 
      RegWrite(2, "REG_DWORD", RegPath, "Hidden")
  PostMessage(0x111, 41504, , , "ahk_id " ID) ; or Send {AppsKey}e
}

Return