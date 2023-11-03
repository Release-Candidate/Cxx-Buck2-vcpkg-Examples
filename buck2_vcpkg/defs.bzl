# SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
# SPDX-License-Identifier: MIT
#
# Project:  Cxx-Buck2-vcpkg-Examples
# File:     defs.bzl
# Date:     03.Nov.2023
#
# ==============================================================================

def _install_vcpkgs_impl(ctx: AnalysisContext)  -> list[Provider]:

    output = ctx.actions.declare_output("vcpkg", dir=True)
    cmd = cmd_args([ctx.attrs._run_vcpkg[RunInfo]])
    cmd.add("-d")
    cmd.add(ctx.attrs.dir)
    cmd.add("-o")
    cmd.add(output.as_output())
    cmd.add("-t")
    cmd.add(ctx.attrs.triple)
    cmd.add(ctx.attrs.manifest)

    ctx.actions.run(cmd, category="run_vcpkg")

    return [DefaultInfo(default_output=output)]

install_vcpkgs = rule(impl = _install_vcpkgs_impl,
    attrs = {
        "dir": attrs.source(),
        "manifest": attrs.string(),
        "triple": attrs.string(),
        "_run_vcpkg": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default="//buck2_vcpkg:run_vcpkg"))
    }
)
