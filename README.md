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

This uses the cask in this repository to place `Netraffic.app` in Applications. Homebrew can later update it with `brew upgrade --cask netraffic` when a new version is published. To remove it, run `brew uninstall --cask netraffic`.

### Manually

1. Download this repository as a ZIP from GitHub and unzip it, or clone it with Git.
2. Move `Netraffic.app` to your Applications folder.
3. Open `Netraffic.app`. If macOS warns that it cannot verify the developer, Control-click the app and choose **Open**, then confirm. This app is not notarized.

Netraffic runs in the menu bar and does not show a Dock icon or main window. Click its speed display to find **Quit Netraffic**. To have it open when you sign in, add it in **System Settings → General → Login Items**.

## Build it yourself

Install the Xcode command line tools, then run:

```sh
./build.sh
open Netraffic.app
```

The build makes a universal macOS app for Apple Silicon and Intel. It uses only macOS system frameworks and Python's standard library.

## How speeds are measured

Netraffic reads byte counters from macOS's primary network interface and calculates the difference each second. `B`, `K`, `M`, and `G` mean bytes, kilobytes, megabytes, and gigabytes **per second** (decimal units). The `/s` suffix is omitted from the compact menu bar display. When the primary interface changes, the display briefly shows dashes while it starts a new measurement.
