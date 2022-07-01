# digibyte-desktop-install
### Easy bash script for installing DigiByte Core desktop entry with icon on most Linux systems.


- Will work on any GUI system that uses FreeDesktop (https://specifications.freedesktop.org/desktop-entry-spec/latest/)
- To run from current path, place the script in the root of your installation folder (outside of the bin folder)
- Make sure to make the script executable (chmod +x) or by going into the file properties and allow to execute as a program.

## Usage
### Snapcraft & Custom Path
```text
curl -sSL https://github.com/Sbosvk/digibyte-desktop-install/raw/main/desktop-install.sh | bash
```

### Current path
Download release file or copy 'desktop-install.sh" to your installation root folder.

### Path alternatives
- Current path
- Snapcraft
- Custom path

### Install with snap
- Can create launcher to digibyte-core snap installation
- Will install digibyte-core through snap if not already installed