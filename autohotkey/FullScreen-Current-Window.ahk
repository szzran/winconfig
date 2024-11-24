; Author:   dmnmsc
; Reddit:   https://www.reddit.com/user/dmnmsc/

#Requires AutoHotkey v2.0
!+f:: FullScreen("A") ; press ctrl+shift+F11 to fullscreen the current window

; Toggle fullscreen
; uses same parameters as WinExist
FullScreen(winTitle*) {
    static MONITOR_DEFAULTTONEAREST := 0x00000002
    static WS_CAPTION := 0x00C00000
    static WS_SIZEBOX := 0x00040000
    static Border := WS_CAPTION | WS_SIZEBOX
    static IsBorderless := "AHK:BorderlessFullscreen"
    static IsMaxed := "AHK:FullscreenPrevMax"
    static propX := "AHK:FullscreenPrevX"
    static propY := "AHK:FullscreenPrevY"
    static propW := "AHK:FullscreenPrevW"
    static propH := "AHK:FullscreenPrevH"

    if !hwnd := WinExist(winTitle*)
        return 0
    if WinGetClass(hwnd) = "ApplicationFrameWindow" {
        Send "#+{Enter}"
        return
    }
    if WinGetClass(hwnd) = "CabinetWClass" && WinGetProcessName(hwnd) = "explorer.exe" {
        ControlSend "{F11}", hwnd
        return
    }
    if !GetProp(hwnd, IsBorderless) { ; If not borderless
        GetWindowPlacement(hwnd, &X, &Y, &W, &H)
        SetProp(hwnd, propX, X, propY, Y, propW, W, propH, H)
        if maxState := WinGetMinMax(hwnd) = 1 ? true : false { ; Save max state
            WinGetPos(&X, &Y, &W, &H, hwnd)
            SetWindowPlacement(hwnd, X, Y, W, H) ; Make transition smoother between restoring and fullscreen
            WinRestore hwnd ; Restore window if maximized, some windows can't be moved if maximized
        }
        SetProp(hwnd, IsMaxed, maxState) ; Save minmax state
        WinSetStyle("-" Border, hwnd) ; Remove caption and sizebox from window
        NumPut("uint", 40, monInfo := Buffer(40))
        DllCall("GetMonitorInfo"
            , "ptr", DllCall("MonitorFromWindow", "ptr", hwnd, "uint", MONITOR_DEFAULTTONEAREST) ; hMonitor from nearest monitor to window
            , "ptr", monInfo)
        WinMove(
            monLeft := NumGet(monInfo, 4, "int"),
            monTop := NumGet(monInfo, 8, "int"),
            monWidth := (monRight := NumGet(monInfo, 12, "Int") - monLeft),
            monHeight := (monBottom := NumGet(monInfo, 16, "int") - monTop),
            hwnd)
        SetProp(hwnd, IsBorderless, 1)
    } else { ; Restore borders and original position
        WinSetStyle "+" Border, hwnd
        X := GetProp(hwnd, propX), Y := GetProp(hwnd, propY), W := GetProp(hwnd, propW), H := GetProp(hwnd, propH)
        if GetProp(hwnd, IsMaxed)
            WinMaximize hwnd
        SetWindowPlacement(hwnd, X, Y, W, H)
        SetProp(hwnd, IsBorderless, 0)
    }

    SetProp(win, propValue*) {
        if propValue.Length & 1
            throw Error("Invalid number of parameters.", -1)
        loop propValue.Length // 2 {
            prop := propValue[A_Index * 2 - 1], value := propValue[A_Index * 2]
            DllCall("SetProp", "ptr", win, "str", prop, "ptr", value)
        }
    }

    GetProp(win, name) => DllCall("GetProp", "ptr", WinExist(win), "str", name)

    GetWindowPlacement(hwnd, &X, &Y, &W, &H) {
        NumPut("uint", 44, WP := Buffer(44, 0))
        DllCall("GetWindowPlacement", "Ptr", hwnd, "Ptr", WP)
        X := NumGet(WP, 28, "Int")
        Y := NumGet(WP, 32, "Int")
        W := NumGet(WP, 36, "Int") - X
        H := NumGet(WP, 40, "Int") - Y
    }

    SetWindowPlacement(hwnd, X, Y, W, H) {
        NumPut("uint", 44, WP := Buffer(44, 0))
        DllCall("GetWindowPlacement", "Ptr", hwnd, "Ptr", WP)
        NumPut("uint", 4, WP, 4) ; WPF_ASYNCWINDOWPLACEMENT
        NumPut("int", X, WP, 28)
        NumPut("int", Y, WP, 32)
        NumPut("int", W + X, WP, 36)
        NumPut("int", H + Y, WP, 40)
        DllCall("SetWindowPlacement", "ptr", hwnd, "ptr", WP)
    }
}