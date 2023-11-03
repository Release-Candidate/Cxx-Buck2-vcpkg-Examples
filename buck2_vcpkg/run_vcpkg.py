# SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
# SPDX-License-Identifier: MIT
#
# Project:  Cxx-Buck2-vcpkg-Examples
# File:     run_vcpkg.py
# Date:     02.Nov.2023
#
# ==============================================================================

import argparse
from pathlib import Path
import subprocess
import sys


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-d",
        "--dir",
        required=True,
        metavar="VCPKG_ROOT",
        help="The path to the vcpkg root, the cloned git repository.",
    )
    parser.add_argument(
        "-l",
        "--log",
        required=True,
        help="The path to the log file to generate.",
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
    log = ""
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
            universal_newlines=True,
            capture_output=True,
            encoding="utf-8",
        )
        log += out.stdout
        log += out.stderr
        with open(args.log, "wt", encoding="utf-8") as log_file:
            log_file.write(log)
        if out.returncode != 0:
            sys.exit(1)

    manifest_root = Path(args.manifest).parent.resolve()
    out = subprocess.run(
        [
            vcpkg_exe,
            "install",
            f"--vcpkg-root={vcpkg_root}",
            f"--triplet={args.triple}",
            f"--x-install-root={manifest_root}",
            f"--x-manifest-root={manifest_root}",
        ],
        cwd=manifest_root,
        universal_newlines=True,
        capture_output=True,
        encoding="utf-8",
    )
    log += out.stdout
    log += out.stderr
    with open(args.log, "wt+", encoding="utf-8") as log_file:
        log_file.write(log)

    if out.returncode != 0:
        sys.exit(2)


if __name__ == "__main__":
    main()
