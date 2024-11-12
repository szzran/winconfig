// ==WindhawkMod==
// @id              dark-window-titlebar
// @name            Dark Window Titlebar for Win32 App
// @description     Hack to enable dark titlebar for win32 app when system darkmode is on.
// @version         1.0.0
// @author          Fifv
// @github          https://github.com/fifv
// @include         dopus.exe
// @include         dopusrt.exe
// @include         GoldenDict.exe
// @include         SyncTrayzor.exe
// @include         Proxifier.exe
// @include         javaw.exe
// @include         tabby.exe
// @include         EXE64.exe
// @include         Notion.exe
// @include         Bandizip.exe
// @compilerOptions -ldwmapi
// ==/WindhawkMod==

// ==WindhawkModReadme==
/*
Hack to enable dark titlebar for win32 app when system darkmode is on.

### Usage

Add any processes you want to enable dark titlebar in **Advanced** > **Custom
process inclusion list**

Only hook on apps creating window, so apps may needed to be restarted.

### Credit

I learnt how to do this from
https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/apply-windows-themes#enable-a-dark-mode-title-bar-for-win32-applications
*/
// ==/WindhawkModReadme==

// ==WindhawkModSettings==

// ==/WindhawkModSettings==

#include <dwmapi.h>
#include <libloaderapi.h>
#include <minwindef.h>
#include <processthreadsapi.h>
#include <windhawk_api.h>
#include <windows.h>
#include <chrono>
#include <string>
#include <thread>
#include <vector>

#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif

auto hWnds = std::vector<HWND>();
DWORD g_pid;

BOOL shouldHackDwmDarkTitlebar(HWND hWnd) {
    if (!IsWindow(hWnd)) {
        return FALSE;
    }
    BOOL oldDwmValue;
    ::DwmGetWindowAttribute(hWnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &oldDwmValue,
                            sizeof(oldDwmValue));
    auto isLightTitlebar = oldDwmValue == 0;

    // BOOL isTopLevel = !(GetWindowLong(hWnd, GWL_STYLE) & WS_CHILD);

    WCHAR _buffer_moduleName[MAX_PATH] = {0};
    GetWindowModuleFileNameW(hWnd, _buffer_moduleName, MAX_PATH);
    auto moduleName = std::wstring(_buffer_moduleName);

    WCHAR _buffer_className[MAX_PATH] = {0};
    GetClassNameW(hWnd, _buffer_className, MAX_PATH);
    auto className = std::wstring(_buffer_className);

    // BOOL isIME = moduleName.ends_with(L"ime") ||
    //              moduleName.ends_with(L"MSCTF.dll") ||
    //              className.find(L"IME") != std::string::npos;

    // return isTopLevel && !isIME && isLightTitlebar;

    auto style = GetWindowLongPtrW(hWnd, GWL_STYLE);
    auto hasBorder = (style & WS_CAPTION) != 0;
    // Wh_Log(
    //     L"hWnd %#08x, hasBorder %d, isLightTitlebar %d, ClassName: %s, "
    //     L"moduleName: %s",
    //     hWnd, hasBorder, isLightTitlebar, _buffer_className,
    //     _buffer_moduleName);

    // auto isVisible = (style & WS_VISIBLE) != 0; /* Don't check this, some
    // windows will be invisible first... */
    return hasBorder && isLightTitlebar;
}
void hackDwmDarkTitlebar(HWND hWnd) {
    // Wh_Log(L"oldDwmValue: %d, hWnd: %#08x, top: %d, module: %s, isIME:
    // %d",
    //        oldDwmValue, hWnd, isTopLevel, moduleName, isIME);

    hWnds.push_back(hWnd);
    BOOL dwmValue = TRUE;
    ::DwmSetWindowAttribute(hWnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &dwmValue,
                            sizeof(dwmValue));
}
void unhackDwmDarkTitlebar(HWND hWnd) {
    /*
        This must be checked, otherwise apps will crash
    */
    if (!IsWindow(hWnd)) {
        return;
    }
    BOOL dwmValue = FALSE;
    ::DwmSetWindowAttribute(hWnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &dwmValue,
                            sizeof(dwmValue));
}

BOOL CALLBACK InitEnumWindowsCallback(HWND hWnd, LPARAM lParam) {
    // Wh_Log(L"InitEnumWindowsCallback");

    DWORD processId;
    GetWindowThreadProcessId(hWnd, &processId);
    if (processId == g_pid) {
        // Wh_Log(L"PID: %llu", processId);
        if (shouldHackDwmDarkTitlebar(hWnd)) {
            WCHAR _buffer_moduleName[MAX_PATH] = {0};
            GetWindowModuleFileNameW(hWnd, _buffer_moduleName, MAX_PATH);

            WCHAR _buffer_className[MAX_PATH] = {0};
            GetClassNameW(hWnd, _buffer_className, MAX_PATH);

            Wh_Log(L"HACK hWnd: %#08x, ClassName: %s, moduleName: %s", hWnd,
                   _buffer_className, _buffer_moduleName);
            hackDwmDarkTitlebar(hWnd);

            /*
                same
            */
            // auto hInst = (HMODULE)GetWindowLongPtrW(hWnd, GWLP_HINSTANCE);
            // Wh_Log(L"hinst: %#08x", hInst);
            // WCHAR _buffer[MAX_PATH] = {0};
            // GetModuleFileNameW(hInst, _buffer, MAX_PATH);
            // Wh_Log(L"%s", _buffer);
        }
    }

    return TRUE;
}

using CreateWindowExW_t = decltype(&CreateWindowExW);
CreateWindowExW_t CreateWindowExW_Original;
HWND WINAPI CreateWindowExW_Hook(DWORD dwExStyle,
                                 LPCWSTR lpClassName,
                                 LPCWSTR lpWindowName,
                                 DWORD dwStyle,
                                 int X,
                                 int Y,
                                 int nWidth,
                                 int nHeight,
                                 HWND hWndParent,
                                 HMENU hMenu,
                                 HINSTANCE hInstance,
                                 LPVOID lpParam) {
    HWND hWnd = CreateWindowExW_Original(dwExStyle, lpClassName, lpWindowName,
                                         dwStyle, X, Y, nWidth, nHeight,
                                         hWndParent, hMenu, hInstance, lpParam);

    if (!hWnd) {
        return hWnd;
    }

    if (shouldHackDwmDarkTitlebar(hWnd)) {
        Wh_Log(L"HACK hWnd: %#08x", hWnd);
        hackDwmDarkTitlebar(hWnd);
    }

    return hWnd;
}

using CreateDialogIndirectParamW_t = decltype(&CreateDialogIndirectParamW);
CreateDialogIndirectParamW_t CreateDialogIndirectParamW_Original;
HWND WINAPI CreateDialogIndirectParamW_Hook(HINSTANCE hInstance,
                                            LPCDLGTEMPLATEW lpTemplate,
                                            HWND hWndParent,
                                            DLGPROC lpDialogFunc,
                                            LPARAM dwInitParam) {
    HWND hWnd = CreateDialogIndirectParamW_Original(
        hInstance, lpTemplate, hWndParent, lpDialogFunc, dwInitParam);

    if (!hWnd) {
        return hWnd;
    }

    if (shouldHackDwmDarkTitlebar(hWnd)) {
        Wh_Log(L"HACK hWnd: %#08x", hWnd);
        hackDwmDarkTitlebar(hWnd);
    }
    return hWnd;
}

using CreateDialogParamW_t = decltype(&CreateDialogParamW);
CreateDialogParamW_t CreateDialogParamW_Original;
HWND WINAPI CreateDialogParamW_Hook(HINSTANCE hInstance,
                                    LPCWSTR lpTemplateName,
                                    HWND hWndParent,
                                    DLGPROC lpDialogFunc,
                                    LPARAM dwInitParam) {
    HWND hWnd = CreateDialogParamW_Original(
        hInstance, lpTemplateName, hWndParent, lpDialogFunc, dwInitParam);

    if (!hWnd) {
        return hWnd;
    }

    if (shouldHackDwmDarkTitlebar(hWnd)) {
        Wh_Log(L"HACK hWnd: %#08x", hWnd);
        hackDwmDarkTitlebar(hWnd);
    }

    return hWnd;
}

DLGPROC Dlgproc_Original;
CALLBACK INT_PTR Dlgproc(HWND unnamedParam1,
                         UINT unnamedParam2,
                         WPARAM unnamedParam3,
                         LPARAM unnamedParam4) {
    switch (unnamedParam2) {
        case WM_INITDIALOG: {
            /*
                oHHHHH WORKS!!!
            */
            EnumWindows(InitEnumWindowsCallback, NULL);
        }
    }
    return Dlgproc_Original(unnamedParam1, unnamedParam2, unnamedParam3,
                            unnamedParam4);
}
using DialogBoxIndirectParamW_t = decltype(&DialogBoxIndirectParamW);
DialogBoxIndirectParamW_t DialogBoxIndirectParamW_Original;
INT_PTR WINAPI DialogBoxIndirectParamW_Hook(HINSTANCE hInstance,
                                            LPCDLGTEMPLATEW hDialogTemplate,
                                            HWND hWndParent,
                                            DLGPROC lpDialogFunc,
                                            LPARAM dwInitParam) {
    Dlgproc_Original = lpDialogFunc;
    /*
        here the parent is the parent, obviously, not the dialog
    */
    Wh_Log(L"aaa, %#08x", hWndParent);
    INT_PTR res = DialogBoxIndirectParamW_Original(
        hInstance, hDialogTemplate, hWndParent, Dlgproc, dwInitParam);

    Wh_Log(L"ohh");
    // EnumWindows(InitEnumWindowsCallback, NULL);

    return res;
}

BOOL CALLBACK OnModUninit() {
    for (std::vector<HWND>::iterator it = hWnds.begin(); it != hWnds.end();
         it++) {
        unhackDwmDarkTitlebar(*it);
        Wh_Log(L"UNHACK hWnd: %#08x", *it);
    }

    return TRUE;
}

void LoadSettings() {}

BOOL Wh_ModInit() {
    // Wh_Log(L"Wh_ModInit");
    g_pid = GetCurrentProcessId();

    LoadSettings();

    Wh_SetFunctionHook((void*)CreateWindowExW, (void*)CreateWindowExW_Hook,
                       (void**)&CreateWindowExW_Original);
    Wh_SetFunctionHook((void*)CreateDialogIndirectParamW,
                       (void*)CreateDialogIndirectParamW_Hook,
                       (void**)&CreateDialogIndirectParamW_Original);
    Wh_SetFunctionHook((void*)CreateDialogParamW,
                       (void*)CreateDialogParamW_Hook,
                       (void**)&CreateDialogParamW_Original);
    Wh_SetFunctionHook((void*)DialogBoxIndirectParamW,
                       (void*)DialogBoxIndirectParamW_Hook,
                       (void**)&DialogBoxIndirectParamW_Original);

    Wh_Log(L"TID: %llu, PID: %llu ", GetCurrentThreadId(),
           GetCurrentProcessId());

    EnumWindows(InitEnumWindowsCallback, NULL);
    return TRUE;
}

void Wh_ModUninit() {
    // Wh_Log(L"Wh_ModUninit");

    OnModUninit();
}

void Wh_ModSettingsChanged() {
    Wh_Log(L"Wh_ModSettingsChanged");

    LoadSettings();
}
