#Requires AutoHotkey v1.1+
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; GUI Creation (initially hidden)
Gui, Add, ListBox, x10 y10 w300 h200 vProxyList gSelectProxy,
Gui, Add, Button, x10 y220 w100 h30 gSetProxy, Set Proxy
Gui, Add, Button, x120 y220 w100 h30 gDisableProxy, Disable Proxy
Gui, Add, Button, x230 y220 w80 h30 gCheckProxy, Check Proxy
Gui, Add, Text, x10 y260 w300 h50 vProxyStatus, Proxy Status: Not checked

; Load proxies from file
ProxyArray := []

if (!FileExist("proxies.txt")) {
    FileAppend,
    (
    ; Add proxies in the format server:port, one per line
    ; Example:
    ; 127.0.0.1:10808
    ; 192.168.42.129:8080
    ), proxies.txt
    GuiControl,, ProxyStatus, Created proxies.txt. Add proxies to the file.
}

FileRead, ProxyFile, proxies.txt
if (ErrorLevel) {
    MsgBox, Could not read proxies.txt
    ExitApp
}

Loop, parse, ProxyFile, `n, `r
{
    line := Trim(A_LoopField)
    if (line != "" && SubStr(line, 1, 1) != ";") {  ; Ignore empty lines and comments
        ProxyArray.Push(line)
    }
}

; Update ListBox with proxies
GuiControl, , ProxyList, |  ; Clear the ListBox
for index, proxy in ProxyArray {
    GuiControl, , ProxyList, %proxy%
}

; Update status if no valid proxies found
if (ProxyArray.Length() = 0) {
    GuiControl,, ProxyStatus, No valid proxies found in proxies.txt
}

return

SelectProxy:
    Gui, Submit, NoHide
    SelectedProxy := ProxyList
return

SetProxy:
    Gui, Submit, NoHide
    if (!SelectedProxy) {
        GuiControl, , ProxyStatus, Please select a proxy first
        return
    }

    ; Split proxy into server and port
    RegExMatch(SelectedProxy, "(.+):(\d+)", ProxyParts)
    ProxyServer := ProxyParts1
    ProxyPort := ProxyParts2

    ; Set Windows proxy
    RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable, 1
    RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyServer, %ProxyServer%:%ProxyPort%

    ; Refresh Internet Settings
    DllCall("wininet\InternetSetOption", "int", 0, "int", 39, "int", 0, "int", 0)
    DllCall("wininet\InternetSetOption", "int", 0, "int", 37, "int", 0, "int", 0)

    GuiControl, , ProxyStatus, Proxy set to: %SelectedProxy%
return

DisableProxy:
    ; Disable Windows proxy
    RegWrite, REG_DWORD, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable, 0

    ; Refresh Internet Settings
    DllCall("wininet\InternetSetOption", "int", 0, "int", 39, "int", 0, "int", 0)
    DllCall("wininet\InternetSetOption", "int", 0, "int", 37, "int", 0, "int", 0)

    GuiControl, , ProxyStatus, Proxy disabled
return

CheckProxy:
    ; Check proxy status
    RegRead, ProxyEnable, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyEnable
    if (ProxyEnable = 1) {
        RegRead, ProxyServer, HKCU, Software\Microsoft\Windows\CurrentVersion\Internet Settings, ProxyServer
        GuiControl, , ProxyStatus, Proxy enabled: %ProxyServer%
    } else {
        GuiControl, , ProxyStatus, No proxy enabled
    }
return

GuiClose:
    Gui, Cancel

; Hotkey to toggle GUI (Ctrl + Alt + M)
^!m::
    Gui, Show, w320 h285, Proxy Manager
return