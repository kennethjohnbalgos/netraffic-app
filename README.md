# Netraffic

Netraffic is a small macOS menu bar app that shows your current upload and download speeds. The upper row (↑) is upload; the lower row (↓) is download. Values refresh every second.

## Requirements

- macOS 13 or later
- Apple Silicon or Intel Mac

## Install the ready-made app

### With Homebrew

```sh
brew tap kennethjohnbalgos/netraffic-app https://github.com/kennethjohnbalgos/netraffic-app.git
brew install --cask kennethjohnbalgos/netraffic-app/netraffic
```

This uses the cask in this repository to place `Netraffic.app` in Applications. Homebrew can later update it with `brew upgrade --cask netraffic` when a new version is published.

### Manually

1. Download this repository as a ZIP from GitHub and unzip it, or clone it with Git.
2. Move `Netraffic.app` to your Applications folder.
3. Open `Netraffic.app`. This release is not notarized by Apple, so macOS may block its first launch. If you see **“Netraffic” Not Opened**, click **Done**, then open **System Settings → Privacy & Security**. Scroll to **Security**, click **Open Anyway** for Netraffic, and confirm with your Mac password if prompted. Apple makes this option available for about an hour after the blocked launch. [Apple's instructions](https://support.apple.com/en-us/102445) explain the same process.

Netraffic runs in the menu bar and does not show a Dock icon or main window. Click its speed display to choose **Start at Login** or **Quit Netraffic**. A checkmark means login startup is enabled. A dash means macOS needs your approval; use **System Settings → General → Login Items** to enable it.

## Uninstall

First click the speed display in the menu bar and turn off **Start at Login** if it is enabled, then choose **Quit Netraffic**. If you added Netraffic directly in **System Settings → General → Login Items**, remove it there too.

- **Homebrew installation:** Run `brew uninstall --cask netraffic`. You can optionally remove the tap afterward with `brew untap kennethjohnbalgos/netraffic-app`.
- **Manual installation:** Move `Netraffic.app` from your Applications folder to the Trash.

## Build it yourself

Install the Xcode command line tools, then run:

```sh
./build.sh
open Netraffic.app
```

The build makes a universal macOS app for Apple Silicon and Intel. It uses only macOS system frameworks and Python's standard library.

## How speeds are measured

Netraffic reads byte counters from macOS's primary network interface and calculates the difference each second. `B`, `K`, `M`, and `G` mean bytes, kilobytes, megabytes, and gigabytes **per second** (decimal units). The `/s` suffix is omitted from the compact menu bar display. When the primary interface changes, the display briefly shows dashes while it starts a new measurement.
