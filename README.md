# AutoHotkey Proxy Manager

## Description
AutoHotkey Proxy Manager is a lightweight Windows utility built with AutoHotkey to manage proxy settings via a graphical user interface (GUI). It allows users to load a list of proxy servers from a text file, select a proxy, enable it in Windows, disable the proxy, and check the current proxy status. The GUI can be toggled using the `Ctrl + Alt + M` hotkey, making it convenient for quick proxy management.

## Features
- Load proxy servers and ports from a `proxies.txt` file.
- Display proxies in a selectable list within a GUI.
- Enable a selected proxy in Windows Internet Settings.
- Disable the active proxy with a single click.
- Check and display the current proxy status.
- Toggle the GUI using `Ctrl + Alt + M`.
- Simple and intuitive interface for proxy management.

## Installation
1. **Install AutoHotkey**: Download and install [AutoHotkey v1.1+](https://www.autohotkey.com/) if not already installed.
2. **Download the Script**: Clone this repository or download the `ProxyManager.ahk` file.
3. **Prepare Proxies File**:
   - Create a `proxies.txt` file in the same directory as `ProxyManager.ahk`.
   - List proxies in the format `server:port` (e.g., `127.0.0.1:10808`), one per line.
4. **Run the Script**: Double-click `ProxyManager.ahk` to launch (may require running as administrator for registry access).

## Usage
1. Launch the script.
2. Press `Ctrl + Alt + M` to show the GUI.
3. Select a proxy from the list.
4. Click **Set Proxy** to enable the selected proxy in Windows.
5. Click **Disable Proxy** to turn off the proxy.
6. Click **Check Proxy** to view the current proxy status.
7. Press `Ctrl + Alt + M` again to hide the GUI (if using the toggle version).

## File Structure
- `ProxyManager.ahk`: The main AutoHotkey script.
- `proxies.txt`: A text file containing proxy server addresses (create this manually).

## Example `proxies.txt`
```
127.0.0.1:10808
192.168.42.129:8080
```

## Requirements
- Windows 7 or later.
- AutoHotkey v1.1 or higher.
- Administrative privileges for modifying Windows proxy settings.

## Notes
- Ensure `proxies.txt` is correctly formatted to avoid loading issues.
- Run the script as administrator if you encounter permission errors when setting proxies.
- The script modifies the Windows registry under `HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings`.

## License
This project is licensed under the [MIT License](LICENSE).

## Acknowledgments
- Built with [AutoHotkey](https://www.autohotkey.com/).
- Inspired by the need for simple proxy management on Windows.