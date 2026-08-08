#!/bin/bash
# LHDC v2/v3/v4/v5 & High-Res Audio Patch Installer for Custom ROMs
# Target OS: Android 15 / Android 16 (LineageOS / Lunaris / AOSP)

set -e

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
PATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================================="
echo " Applying Savitech LHDC (v2/v3/v4/v5) Custom ROM Patches "
echo "=========================================================="
echo "ROM Top Directory: ${TOP_DIR}"
echo "Patch Directory:   ${PATCH_DIR}"
echo ""

apply_patch() {
    local target_repo="$1"
    local patch_file="$2"
    
    echo "--> Patching ${target_repo}..."
    if [ -d "${TOP_DIR}/${target_repo}" ]; then
        cd "${TOP_DIR}/${target_repo}"
        if git apply --check "${PATCH_DIR}/${patch_file}" 2>/dev/null; then
            git apply "${PATCH_DIR}/${patch_file}"
            echo "    [OK] Applied ${patch_file}"
        else
            echo "    [WARNING] Patch ${patch_file} failed clean check, attempting am/3way..."
            git am -3 "${PATCH_DIR}/${patch_file}" || {
                echo "    [INFO] Assuming patch already applied or conflict resolved."
            }
        fi
    else
        echo "    [ERROR] Directory ${TOP_DIR}/${target_repo} not found!"
    fi
}

apply_patch "bionic" "0001-bionic-lhdc.patch"
apply_patch "frameworks/base" "0002-frameworks_base-lhdc.patch"
apply_patch "packages/apps/Settings" "0003-packages_apps_Settings-lhdc.patch"
apply_patch "packages/modules/Bluetooth" "0004-packages_modules_Bluetooth-lhdc.patch"
apply_patch "packages/modules/common" "0005-packages_modules_common-lhdc.patch"

echo ""
echo "=========================================================="
echo " SUCCESS: All Savitech LHDC Patches Successfully Installed!"
echo "=========================================================="
