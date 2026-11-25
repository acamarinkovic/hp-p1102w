#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 || ! -d "$1" ]]; then
    printf 'Usage: %s EXISTING_OUTPUT_DIRECTORY\n' "$0" >&2
    exit 2
fi

output_directory=$1
[[ "$output_directory" = /* ]] || output_directory="./$output_directory"
package_name=HP_P1102_Native_macOS.pkg
output_package="$output_directory/$package_name"
if [[ -d "$output_package" ]]; then
    printf 'Package path is a directory: %s\n' "$output_package" >&2
    exit 2
fi

readonly source_url=https://github.com/danielbchurchill/hp-p1102w-macos-driver.git
readonly source_commit=ddb582f38be917947303488595c4125e9fac073b
readonly driver_install_location=/Library/Printers/HP_P1102_Native
readonly driver_display_name='HP LaserJet Professional P1102/P1102w (Apple Silicon)'
build_directory=$(mktemp -d "${TMPDIR:-/tmp}/hp-p1102-native.XXXXXXXX")
trap 'rm -rf -- "$build_directory"' EXIT

source_directory="$build_directory/source"
git_environment=$(/usr/bin/git rev-parse --local-env-vars)
while IFS= read -r variable; do
    unset "$variable"
done <<< "$git_environment"

/usr/bin/git init --quiet "$source_directory"
/usr/bin/git -C "$source_directory" fetch --quiet --depth=1 "$source_url" "$source_commit"
/usr/bin/git -C "$source_directory" checkout --quiet --detach "$source_commit"
/usr/bin/arch -arm64 /usr/bin/make -C "$source_directory" ARCHS='-arch arm64' LIBUSB= \
    CC="/usr/bin/clang -DFOO2ZJS_PATH='\"$driver_install_location/bin/foo2zjs\"'" test

driver_root="$build_directory/driver"
ppd_root="$build_directory/ppd"
/usr/bin/install -d -m 0755 "$driver_root/bin" "$driver_root/filter" "$ppd_root"
for executable in foo2zjs rastertozjs; do
    /usr/bin/lipo -verify_arch arm64 "$source_directory/build/$executable"
done
/usr/bin/install -m 0755 "$source_directory/build/foo2zjs" "$driver_root/bin/foo2zjs"
/usr/bin/install -m 0755 "$source_directory/build/rastertozjs" "$driver_root/filter/rastertozjs"
/usr/bin/install -m 0644 "$source_directory/LICENSE" "$driver_root/LICENSE"
/usr/bin/install -m 0644 "$source_directory/vendor/foo2zjs/UPSTREAM.md" "$driver_root/UPSTREAM.md"
/usr/bin/sed -e "s|/Library/Printers/HP_P1102w_ZJS|$driver_install_location|g" \
    -e "s|^\*NickName:.*|*NickName: \"$driver_display_name\"|" \
    "$source_directory/ppd/HP-LaserJet-P1102w-ZJS.ppd" > "$ppd_root/HP-LaserJet-P1102-Native.ppd"
/bin/chmod 0644 "$ppd_root/HP-LaserJet-P1102-Native.ppd"

/usr/bin/pkgbuild --root "$driver_root" --identifier io.github.acamarinkovic.p1102w.native.driver \
    --version 1.0 --install-location "$driver_install_location" "$build_directory/driver.pkg"
/usr/bin/pkgbuild --root "$ppd_root" --identifier io.github.acamarinkovic.p1102w.native.ppd \
    --version 1.0 --install-location /Library/Printers/PPDs/Contents/Resources "$build_directory/ppd.pkg"
/usr/bin/plutil -create xml1 "$build_directory/requirements.plist"
/usr/bin/plutil -insert arch -json '["arm64"]' "$build_directory/requirements.plist"
/usr/bin/plutil -insert os -json '["12.0"]' "$build_directory/requirements.plist"
/usr/bin/productbuild --product "$build_directory/requirements.plist" \
    --package "$build_directory/driver.pkg" --package "$build_directory/ppd.pkg" \
    "$build_directory/$package_name"
/usr/bin/install -S -m 0644 "$build_directory/$package_name" "$output_package"
printf 'Built %s\n' "$output_package"
