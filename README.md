# HP LaserJet P1102 and P1102w Driver for Apple Silicon

Native ARM64 USB printing for the **HP LaserJet Professional P1102 and P1102w** on Apple Silicon Macs running **macOS 12 or later** with CUPS printer-driver support. Maintained by [Aleksandar Marinkovic](https://github.com/acamarinkovic).

Both driver executables run natively on Apple Silicon and use libraries built into macOS.

**[Download the macOS installer](https://github.com/acamarinkovic/hp-p1102w/releases/latest/download/HP_P1102_Native_macOS.pkg)** · [Release notes, checksums, and source](https://github.com/acamarinkovic/hp-p1102w/releases/latest)

## Native driver for Apple Silicon

### Installation

1. [Verify the downloaded installer](#verify-the-download), then open `HP_P1102_Native_macOS.pkg` and follow the Installer prompts. The package is unsigned. If macOS blocks it, see [Open the installer](#open-the-installer).
2. Connect the printer over USB. Open **System Settings → Printers & Scanners** and click **Add Printer, Scanner, or Fax**. On macOS 12, open **System Preferences → Printers & Scanners** and click **+**.
3. Select the printer. Under **Use → Select Software**, choose **HP LaserJet Professional P1102/P1102w (Apple Silicon)**. If you already have a queue for the printer, give the new queue a distinct name such as **HP P1102 Native**.
4. Print a test page. You can make the new queue your default in **Printers & Scanners**.

USB hardware testing covered the HP LaserJet Professional P1102 on macOS 27.2.1. The package also includes the P1102w USB profile.

### Verify the download

Download `SHA256SUMS` from the same release as the installer. In the download folder, run the command below and compare the result with the installer entry in `SHA256SUMS`.

```sh
shasum -a 256 HP_P1102_Native_macOS.pkg
```

### Open the installer

After verifying the download and trying to open the package, go to **System Settings → Privacy & Security**. In the **Security** section, click **Open Anyway** for this installer. On macOS 12, use **System Preferences → Security & Privacy → General**. Confirm **Open** if macOS shows a second prompt and authenticate if asked. If **Open Anyway** is missing, try opening the package again and return to the same settings pane.

## Build the native installer

Use an Apple Silicon Mac with Xcode Command Line Tools and an internet connection.

```sh
mkdir -p dist &&
./tools/build-native-driver.sh dist &&
open dist/HP_P1102_Native_macOS.pkg
```

The build compiles the CUPS filter and ZjStream encoder and runs an offline print test. To build the installer, source archive, and checksums together, run `./tools/build-native-driver.sh --release dist-release` with a new output directory. The [Apple Silicon workflow](.github/workflows/native-driver.yml) builds and tests the installer and publishes releases for `native-v*` tags.

The [release source archive](https://github.com/acamarinkovic/hp-p1102w/releases/latest/download/HP_P1102_Native_Source.tar.gz) contains the GPL-licensed macOS driver by Daniel Churchill and the foo2zjs encoder by Rick Richardson and its contributors.
