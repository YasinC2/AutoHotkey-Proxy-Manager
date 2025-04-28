# AutoHotkey Proxy Manager

## Description
AutoHotkey Proxy Manager is a lightweight Windows utility built with AutoHotkey to manage proxy settings via a graphical user interface (GUI). It allows users to load a list of proxy servers from a text file, select a proxy, enable it in Windows, disable the proxy, and check the current proxy status. The GUI can be opened using the `Ctrl + Alt + M` hotkey, making it convenient for quick proxy management.

## Features
- Load proxy servers and ports from a `proxies.txt` file, refreshed every time the GUI is opened.
- Display proxies in a selectable list within a GUI.
- Enable a selected proxy in Windows Internet Settings.
- Disable the active proxy with a single click.
- Check and display the current proxy status.
- Open the GUI using `Ctrl + Alt + M`.
- Simple and intuitive interface for proxy management.
- Automatically create `proxies.txt` with instructions if it doesn't exist.

## Installation
1. **Install AutoHotkey**: Download and install [AutoHotkey v1.1+](https://www.autohotkey.com/) if not already installed.
2. **Download the Script**: Clone this repository or download the `ProxyManager.ahk` file.
3. **Prepare Proxies File** (Optional):
   - If `proxies.txt` does not exist in the same directory as `ProxyManager.ahk`, it will be created automatically with instructions and example proxies.
   - Edit `proxies.txt` to list proxies in the format `server:port` (e.g., `127.0.0.1:10808`), one per line.
4. **Add to Windows Startup** (Optional):
   - Press `Win + R` to open the Run dialog.
   - Type `shell:startup` and press Enter to open the Startup folder.
   - Create a shortcut to `ProxyManager.ahk`:
     - Right-click `ProxyManager.ahk`, select **Create Shortcut**.
     - Move the shortcut to the Startup folder (drag or copy/paste).
   - The script will now run automatically when Windows starts.
5. **Run the Script**: Double-click `ProxyManager.ahk` to launch (may require running as administrator for registry access).

## Usage
1. Launch the script.
2. Press `Ctrl + Alt + M` to open the GUI and load the latest proxies from `proxies.txt`.
3. Select a proxy from the list (if any are loaded).
4. Click **Set Proxy** to enable the selected proxy in Windows.
5. Click **Disable Proxy** to turn off the proxy.
6. Click **Check Proxy** to view the current proxy status.
7. Close the GUI using the window's close button to hide it; the script remains running.

## File Structure
- `ProxyManager.ahk`: The main AutoHotkey script.
- `proxies.txt`: A text file containing proxy server addresses (automatically created if missing).

## Example `proxies.txt`
```
; Add proxies in the format server:port, one per line
; Example:
; 127.0.0.1:10808
; 192.168.42.129:8080
127.0.0.1:8080
```

## Requirements
- Windows 7 or later.
- AutoHotkey v1.1 or higher.
- Administrative privileges for modifying Windows proxy settings.

## Notes
- If `proxies.txt` is missing, the script creates it with commented instructions and example proxies. Edit the file to add your proxies.
- Lines in `proxies.txt` starting with `;` are treated as comments and ignored.
- Proxies are reloaded from `proxies.txt` each time the GUI is opened, reflecting any changes made to the file.
- Ensure `proxies.txt` is correctly formatted to avoid loading issues.
- Run the script as administrator if you encounter permission errors when setting proxies.
- The script modifies the Windows registry under `HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings`.

## Contributing
Contributions are welcome! Please:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a clear description of changes.

## License
This project is licensed under the [MIT License](LICENSE).

## Acknowledgments
- Built with [AutoHotkey](https://www.autohotkey.com/).
- Inspired by the need for simple proxy management on Windows.