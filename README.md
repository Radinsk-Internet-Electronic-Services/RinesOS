This is beta testing.

OS is currently dependent on Windows until further notice. (this project is mainly focusing on building a working OS with batch files '.bat' so don't expect much)

Issues you may notice:
The OS will refuse to open files like .exe, .dll, and .bat because they are executables that may harm your computer. This
will be changed in a future update that will give you the option to override and take the risk,,

## What's new in 2.12.5

### Bootable configs
- RinesOS can now boot custom "guest" operating systems from `.config` files. Each config sets the OS name, username, color scheme, logo, startup text, hardware info, disabled apps, prompt and custom commands.
- Plug in a USB drive with a valid config and it auto-boots after a 6-second countdown (press M for the menu).
- A USB with no valid config starts **Media Mode** and plays music, video and pictures from the drive.
- Boot menu option 4 can boot a USB, search this computer for configs, or load a config by path. In the terminal, `config load` does the same.
- A config is accepted only if line 1 carries the RinesOS boot code. Other `.config` files (`web.config`, etc.) are ignored.
- Changes made while a config is running (settings, notes, theme, boot count) are saved back into the config. After the first save the body is stored as encoded text.
- New terminal commands: `config` (info, save, export, load, new, set), `mkconfig` (wizard), and `vault` (store up to 9 small files inside the config).
- Includes `RinesOS_Template.config`, `Example_NovaOS.config` and a full guide.

### Password
- Set or remove a login password in **Settings > Password** or with `passwd` / `passwd remove`.
- Asked at every start before the desktop, and also in Safe Mode. Three wrong tries restarts RinesOS.
- Stored as a SHA-256 hash. This is basic session protection, not strong security.

### Update Center
- **Settings > Check for updates** (or `update` in the terminal) lists every release from this repository.
- Open any release to **upgrade or downgrade** to it. Pre-releases are marked, and the newest stable release is marked LATEST.
- Choose the file: `.bat`, 32-bit `.exe` or 64-bit `.exe`. The one matching how you run RinesOS is marked recommended.
- **Install now** downloads the file and checks its size and SHA-256 checksum (when GitHub provides one). It backs up the current file to `%USERPROFILE%\RinesOS_Backups`, replaces itself, then closes and reopens automatically. **Download only** saves it to your Downloads folder.
- Terminal: `update check`, `update list`, `update latest`, `update install N`, `update download N`.

### Other changes
- The Files, Media and Settings apps are unchanged apart from the new menu entries.
- New terminal commands appear in `help`.

### Known limitations
- Windows 10/11 only (uses PowerShell and certutil, both built in).
- Updates need internet access and PowerShell.
- If RinesOS runs from a renamed `.exe` (a name not starting with `RinesOS`), Install is refused. Download only still works.
- Avoid double quotes and exclamation marks in config values.
- A guest "OS" is RinesOS with your name, colors, hardware and commands, not a separate operating system.

### Files in this release
`RinesOS.bat`, the 32-bit and 64-bit `.exe` (console only, Windows/Invisible 32 and 64 bit may be discontinued) builds, `RinesOS_Template.config`, `Example_NovaOS.config`, `RinesOS_Config_Guide.txt`

Current progress and future updates:
1. Adding functionality for exe (will ask if you are sure instead of blocking you)
2. RinesOS will soon be able to transfer media to Rines PulseMedia (Rines' media player) instead of opening Windows media players
3. will add setup process and new system commands

   Still deciding more. Stay tuned for more updates!
