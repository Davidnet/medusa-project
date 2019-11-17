#!/bin/bash
#
# Download from nvidia packages to build GPU containers for balena
# Davidnet (david@kiwicampus.com)
set -euo pipefail
IFS=$'\n\t'

NVIDIA_URL="https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/"

FILE_LIST=(
    "Tegra186_Linux_R28.2.1_aarch64.tbz2"
    "cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb"
    "libcudnn7_7.1.5.14-1+cuda9.0_arm64.deb"
    "libcudnn7-dev_7.1.5.14-1+cuda9.0_arm64.deb"
)

if [ -f "Tegra186_Linux_R28.2.1_aarch64.tbz2" ]; then
    echo "L4T files do exist in specified folder! Exiting..."
    exit 0
fi;

# TODO (davidnet): do this in parallel and wait for script to finish
for file in ${FILE_LIST[@]}; do
    wget --quiet --no-clobber "$NVIDIA_URL$file"
done

# TODO (davidnet): Add to get untar to tmp files and get the all the packages from the Tegra186 folder.
TMPDIR=$(mktemp -d) 

cp Tegra186_Linux_R28.2.1_aarch64.tbz2 $TMPDIR

pushd $TMPDIR
tar --strip-components=2 -xvf Tegra186_Linux_R28.2.1_aarch64.tbz2 --wildcards --no-anchored 'Linux_for_Tegra/nv_tegra/*.tbz2'
rm -rf Tegra186_Linux_R28.2.1_aarch64.tbz2
mv nv_sample_apps/nvgstapps.tbz2 .
rm -rf nv_sample_apps
popd

mv $TMPDIR/* .

echo "L4T files downloaded."