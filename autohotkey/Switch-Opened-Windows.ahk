#Requires AutoHotkey v2.0

ExtractAppTitle(FullTitle) {
    return SubStr(FullTitle, (InStr(FullTitle, " ", false, -2) + 1)<1 ? (InStr(FullTitle, " ", false, -2) + 1)-1 : (InStr(FullTitle, " ", false, -2) + 1))
}

HandleChromeWindowsWithSameTitle() {
    FullTitle := WinGetTitle("A")
    AppTitle := ExtractAppTitle(FullTitle)
    SetTitleMatchMode(2)
    owindowsWithSameTitleList := WinGetList(AppTitle,,,)
    awindowsWithSameTitleList := Array()
    windowsWithSameTitleList := owindowsWithSameTitleList.Length
    For v in owindowsWithSameTitleList
    {   awindowsWithSameTitleList.Push(v)
    }
    WinActivate("ahk_id " awindowsWithSameTitleList[awindowsWithSameTitleList.Length])
}

HandleWindowsWithSameProcessAndClass(activeProcessName) {
    activeClass := WinGetClass("A")
    SetTitleMatchMode(2)
    owindowsListWithSameProcessAndClass := WinGetList("ahk_exe " activeProcessName " ahk_class " activeClass,,,)
    awindowsListWithSameProcessAndClass := Array()
    windowsListWithSameProcessAndClass := owindowsListWithSameProcessAndClass.Length
    For v in owindowsListWithSameProcessAndClass
    {   awindowsListWithSameProcessAndClass.Push(v)
    }
    WinActivate("ahk_id " awindowsListWithSameProcessAndClass[awindowsListWithSameProcessAndClass.Length])
}

!`::
{
global
activeProcessName := WinGetProcessName("A")

if (activeProcessName = "chrome.exe") {
    HandleChromeWindowsWithSameTitle()
} else {
    HandleWindowsWithSameProcessAndClass(activeProcessName)
}
Return
}