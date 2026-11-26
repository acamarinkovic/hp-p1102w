Native ARM64 USB printing for the **HP LaserJet Professional P1102 and P1102w** on Apple Silicon Macs running **macOS 12 or later** with CUPS printer-driver support. Maintained by [Aleksandar Marinkovic](https://github.com/acamarinkovic).

This release improves build verification across Xcode versions. GitHub Actions built and installed the native package on macOS 15.

1. Download `HP_P1102_Native_macOS.pkg` and [verify its checksum](https://github.com/acamarinkovic/hp-p1102w#verify-the-download). Open the package and follow the Installer prompts. If macOS blocks the unsigned package, see [Open the installer](https://github.com/acamarinkovic/hp-p1102w#open-the-installer).
2. Connect the printer over USB and open **Printers & Scanners**. On macOS 12, use **System Preferences → Printers & Scanners** and click **+**.
3. Add the printer. Under **Use → Select Software**, choose **HP LaserJet Professional P1102/P1102w (Apple Silicon)**. Use a distinct name such as **HP P1102 Native** if the printer already has a queue.

USB hardware testing covered the HP LaserJet Professional P1102 on macOS 27.2.1. The package also includes the P1102w USB profile. See the [installation guide](https://github.com/acamarinkovic/hp-p1102w#installation) for full setup instructions.

`HP_P1102_Native_Source.tar.gz` contains the exact upstream source used for the build. The build script is included in the tagged repository. `SHA256SUMS` covers the installer and source archive.
