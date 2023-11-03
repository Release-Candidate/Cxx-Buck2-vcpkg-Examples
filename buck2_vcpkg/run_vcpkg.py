# SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
# SPDX-License-Identifier: MIT
#
# Project:  Cxx-Buck2-vcpkg-Examples
# File:     run_vcpkg.py
# Date:     02.Nov.2023
#
# ==============================================================================

import argparse
import os
from pathlib import Path
import subprocess
import sys


################################################################################
def main() -> None:
    """The main entry point of this script."""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-d",
        "--dir",
        required=True,
        metavar="VCPKG_ROOT",
        help="The path to the vcpkg root, the cloned git repository.",
    )
    parser.add_argument(
        "-o",
        "--out_dir",
        required=True,
        help="The path to directory to install the packages in.",
    )
    parser.add_argument(
        "-t",
        "--triple",
        required=True,
        help="The triple describing the CPU architecture, OS and release or debug builds.",
    )
    parser.add_argument(
        "manifest",
        metavar="MANIFEST",
        help="The path to the manifest.",
    )
    args = parser.parse_args()
    vcpkg_root = Path(args.dir).resolve()
    vcpkg_exe = vcpkg_root.joinpath("vcpkg")
    if not vcpkg_exe.is_file():
        vcpkg_bootstrap = vcpkg_root
        if sys.platform == "win32":
            vcpkg_bootstrap = vcpkg_root.joinpath("bootstrap-vcpkg.bat")
        else:
            vcpkg_bootstrap = vcpkg_root.joinpath("bootstrap-vcpkg.sh")
        out = subprocess.run(
            [vcpkg_bootstrap, "-disableMetrics"],
        )
        if out.returncode != 0:
            sys.exit(1)

    manifest_root = Path(args.manifest).parent.resolve()
    out = subprocess.run(
        [
            vcpkg_exe,
            "install",
            f"--vcpkg-root={vcpkg_root}",
            f"--triplet={args.triple}",
            f"--x-install-root={args.out_dir}",
            f"--x-manifest-root={manifest_root}",
        ],
    )
    if out.returncode != 0:
        sys.exit(2)

    link_src = Path(args.out_dir).joinpath(args.triple).resolve()
    link_dst = manifest_root.joinpath("vcpkg").absolute()
    if link_dst.exists():
        os.remove(link_dst)
    os.symlink(link_src, link_dst, target_is_directory=True)


if __name__ == "__main__":
    main()
