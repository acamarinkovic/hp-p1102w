# HP LaserJet Professional P1102 and P1102w drivers for macOS

## Overview

This repository provides a native USB driver for the **HP LaserJet Professional P1102 and P1102w** on Apple Silicon. It also includes the legacy repackaged HP installer for macOS 26 Tahoe and macOS 27 Golden Gate.

HP's official driver package refuses to install on newer macOS releases because its installer checks the macOS version number. This repackage takes the latest official HP driver and replaces only the installer's `Distribution` file with one that has no macOS version check, so the package is no longer tied to a specific macOS version. The driver files themselves are unchanged.

## Native driver for Apple Silicon

The native driver supports USB printing on Apple Silicon Macs running macOS 12 or later. The CUPS filter and ZjStream encoder run without Rosetta, the HP software package, Homebrew, or Ghostscript.

1. Download `HP_P1102_Native_macOS.pkg` and `SHA256SUMS` from the newest Apple Silicon release in [GitHub Releases](https://github.com/acamarinkovic/hp-p1102w/releases). Run `shasum -a 256 HP_P1102_Native_macOS.pkg` in the download folder and compare its output with the installer entry in `SHA256SUMS`. Open the package after the hashes match. If macOS blocks the unsigned installer, follow [Apple's instructions for opening software you trust](https://support.apple.com/en-us/102445).
2. Connect the printer over USB and open **Printers & Scanners** in **System Settings**. On macOS 12, open **System Preferences → Printers & Scanners** and click **+**.
3. Add the USB printer with a distinct name such as **HP P1102 Native**. Under **Use → Select Software**, choose **HP LaserJet Professional P1102/P1102w (Apple Silicon)** for either model.
4. Print a test page from the new queue. To use it for future jobs, select it as the default printer in **Printers & Scanners**.

The installer registers the driver and leaves existing queues in place. The release includes the exact upstream driver source. This driver uses a macOS CUPS PPD and filter. The installer requires macOS 12 or later, and printing depends on continued support for this CUPS driver interface.

### Build the native installer

To rebuild from source, use an Apple Silicon Mac with Xcode Command Line Tools and an internet connection.

```sh
mkdir -p dist &&
./tools/build-native-driver.sh dist &&
open dist/HP_P1102_Native_macOS.pkg
```

The build runs an offline print test using the pinned [GPL-licensed native driver source](https://github.com/danielbchurchill/hp-p1102w-macos-driver/tree/ddb582f38be917947303488595c4125e9fac073b). To build the installer, source archive, and checksums together, run `./tools/build-native-driver.sh --release dist-release`. Use a new output directory for each release build. The [Apple Silicon workflow](.github/workflows/native-driver.yml) also tests installation on an Apple Silicon runner and publishes releases for `native-v*` tags.

## Supported macOS versions

This table applies to the legacy HP package.

| macOS version | Supported |
| --- | --- |
| macOS 26 Tahoe | Yes |
| macOS 27 Golden Gate | Yes |
| Later macOS releases | The installer has no version check. Printing requires Rosetta on Apple Silicon. |

If you're searching for a **P1102w driver for macOS Tahoe**, a **P1102w driver for macOS Golden Gate**, or a driver for whatever macOS comes next, this is the same package.

## Features

*   **Not tied to a macOS version:** The installer no longer checks which version of macOS you're running, so a new macOS release (Tahoe, Golden Gate, or anything after) won't block it.
*   **Based on Latest Official HP Driver:** Ensures you're getting the most up-to-date core driver components from HP, with only the installer check removed.

## Installation

These steps apply to the legacy HP package. For USB printing without Rosetta, see [Native driver for Apple Silicon](#native-driver-for-apple-silicon).

1.  **Apple silicon Macs: install Rosetta first.** HP's printing filters are Intel-only, so they need Rosetta to run. Upgrading to macOS 27 (Golden Gate) removes Rosetta and doesn't put it back, and macOS won't prompt you to reinstall it for a printer driver. Open Terminal and run:

    ```sh
    sudo softwareupdate --install-rosetta --agree-to-license
    ```

    Intel Macs can skip this step.
2.  **Download:** Download `HP_P1102w_macOS_Driver.pkg` from the [latest release](https://github.com/jackcheng/hp-p1102w-tahoe/releases/latest).
3.  **Run Installer:** Double-click the downloaded `.pkg` file to launch the installer and follow the on-screen prompts.
4.  **If macOS blocks the installer:** This is a modified package, not HP's original, so macOS may say it "can't be opened" or is from an unidentified developer. To allow it:
    1. Open **System Settings** > **Privacy & Security**.
    2. Scroll down to the **Security** section, where you'll see a message about the blocked installer.
    3. Click **Open Anyway**, then confirm with your password or Touch ID.
    4. The installer will open. Continue with the on-screen prompts.
5.  **Add Printer:** After installation, go to **System Settings** > **Printers & Scanners** and add your HP LaserJet Professional P1102w printer.

## Troubleshooting

### Printer shows "Software Incompatible"

If the printer queue says **Software Incompatible** or "The printer software is not compatible with this device", and jobs stop with "Data" failed, Rosetta is missing. This is the usual result of upgrading an Apple silicon Mac to macOS 27, and installing Rosetta fixes it (confirmed on macOS 27.2):

1. Run `sudo softwareupdate --install-rosetta --agree-to-license` in Terminal.
2. In **System Settings** > **Printers & Scanners**, remove the P1102w and add it again.
3. Print a test page.

If you want to confirm the cause first, `/var/log/cups/error_log` will contain `Bad CPU type in executable` for `rastertozjs`.

### Future macOS releases

Apple has said Rosetta will only be generally available through macOS 27. HP's driver is Intel-only and can't be recompiled, so it may stop working on Apple silicon in a later macOS release regardless of how it's packaged.

## How the package is built

*   [`package/Distribution`](package/Distribution) is the installer definition used in the package. Compared with HP's original, it removes the `InstallationCheck()` script that rejected newer macOS versions.
*   [`tools/replace_distribution.py`](tools/replace_distribution.py) swaps that file into the package without touching the HP driver payload.
*   The [release workflow](.github/workflows/release.yml) builds the package, signs it with a Developer ID Installer certificate and notarizes it with Apple when those secrets are configured, and publishes it as a GitHub release. Run it from the **Actions** tab with **Run workflow**.

## Disclaimer

This driver package is a community modification and is **not officially supported by HP Inc.** Use at your own discretion. While care has been taken to ensure functionality, there are no guarantees, and neither the creator nor contributors are liable for any issues that may arise from its use.
