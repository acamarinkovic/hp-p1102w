Native USB printing for the HP LaserJet Professional P1102 and P1102w on Apple Silicon Macs running macOS 12 or later. Printing uses the built-in macOS print system and requires no Rosetta or HP software.

1. Download `HP_P1102_Native_macOS.pkg` and `SHA256SUMS`. Run `shasum -a 256 HP_P1102_Native_macOS.pkg` in the download folder. Compare the result with the installer entry in `SHA256SUMS`, then open the package. The package is unsigned. If macOS blocks it, use [Apple's instructions for software you trust](https://support.apple.com/en-us/102445).
2. Connect the printer over USB and open **Printers & Scanners**. On macOS 12, use **System Preferences → Printers & Scanners** and click **+**.
3. Add the printer and select **HP LaserJet Professional P1102/P1102w (Apple Silicon)** under **Use → Select Software**. Use a distinct name such as **HP P1102 Native** if the printer already has a queue.

Verified over USB on an HP LaserJet Professional P1102 running from an Apple Silicon Mac on macOS 27.2.1. The P1102w profile is included. Wi-Fi and physical printing on a P1102w were outside that test.

`HP_P1102_Native_Source.tar.gz` contains the exact upstream source used for the build. The build and packaging script is included in the tagged repository. `SHA256SUMS` covers both release assets.
