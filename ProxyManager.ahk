/*
    AutoHotkey Proxy Manager
    Author: Yasin Asasi
    GitHub: https://github.com/YasinC2/AutoHotkey-Proxy-Manager
    Version: 1.0.0
    Description: A Windows utility to manage proxy settings via a GUI. Loads proxies from proxies.txt,
                 allows selection and enabling/disabling of proxies, and checks proxy status.
    Usage: Run the script, press Ctrl+Alt+M to open the GUI, select a proxy, and use buttons to manage proxies.
    Notes:
    - Requires AutoHotkey v1.1+.
    - Run as administrator for registry modifications (if you encounter permission errors when setting proxies).
    - Proxies.txt should list proxies in server:port format (e.g., 127.0.0.1:8080), one per line.
    - Automatically creates proxies.txt if missing, with commented instructions.
    - Lines in proxies.txt starting with ; are ignored as comments.
    License: MIT
*/

#Requires AutoHotkey v1.1+
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; Global variables
ProxyArray := []
SelectedProxy := ""

; GUI Creation (initially hidden)
Gui, Add, ListBox, x10 y10 w300 h100 vProxyList gSelectProxy,
Gui, Add, Button, x10 y110 w100 h30 gSetProxy, Set Proxy
Gui, Add, Button, x115 y110 w100 h30 gDisableProxy, Disable Proxy
Gui, Add, Button, x220 y110 w90 h30 gCheckProxy, Check Proxy
Gui, Add, Text, x10 y150 w300 h50 vProxyStatus, Proxy Status: Not checked

; Subroutine to load proxies from file
LoadProxies:
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
        ; Gui, Cancel
        ; return
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
    } else {
        GuiControl,, ProxyStatus, % "Proxy Status: Loaded " ProxyArray.Length() " proxies"
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
return

; Hotkey to open GUI and load proxies (Ctrl + Alt + M)
^!m::
    Gui, Show, w320 h175, Proxy Manager
    Gosub, LoadProxies
return