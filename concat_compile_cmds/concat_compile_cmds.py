# SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
# SPDX-License-Identifier: MIT
#
# Project:  c++-test
# File:     concat_compile_cmds.py
# Date:     31.Oct.2023
#
# ==============================================================================

import argparse
import json
import pathlib
import subprocess


################################################################################
def parse_cmd_line() -> argparse.Namespace:
    """Parse the command line arguments. Return an object holding the arguments."""
    parser = argparse.ArgumentParser(
        description="Concatenates the given compile_command.json files to a single one. Sets the 'directory' field to the absolute path of the project's root."
    )
    parser.add_argument(
        "-l",
        "--log",
        required=True,
        help="The path to the log file to generate",
    )
    parser.add_argument(
        "files",
        metavar="FILES",
        nargs="+",
        help="The space separated list of files to concatenate to a single one.",
    )
    return parser.parse_args()


################################################################################
def main() -> None:
    """The main entry point of this script."""
    args = parse_cmd_line()

    buck2_out = args.log

    root_dir = subprocess.check_output(
        ["buck2", "root", "--kind", "project"], text=True
    ).strip()
    out_path = pathlib.Path(root_dir).joinpath("compile_commands.json")

    log_str = "Log of concat_compile_cmds.py\n"

    result: object = {}

    for file in args.files:
        log_str += f"Processing {file} ...\n"
        with open(file, "rt", encoding="utf-8") as fd:
            json_obj = json.load(fd)
            for e in json_obj:
                e["directory"] = root_dir
                result[e["file"]] = e

    with open(out_path, "wt", encoding="utf-8") as out_file:
        json_list = list(result.values())
        out_file.write(json.dumps(json_list, indent=2))

    with open(buck2_out, "wt", encoding="utf-8") as buck2_out_file:
        buck2_out_file.write(log_str)


if __name__ == "__main__":
    main()
