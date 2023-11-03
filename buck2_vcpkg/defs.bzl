# SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
# SPDX-License-Identifier: MIT
#
# Project:  Cxx-Buck2-vcpkg-Examples
# File:     defs.bzl
# Date:     03.Nov.2023
#
# ==============================================================================

# Built-in Triplets:
#   x64-android
#   x64-linux
#   x64-windows
#   arm64-uwp
#   x64-windows-static
#   x86-windows
#   arm-neon-android
#   arm64-windows
#   x64-uwp
#   x64-osx
#   arm64-android
# Community Triplets:
#   wasm32-emscripten
#   x64-xbox-scarlett-static
#   ppc64le-linux
#   x64-xbox-xboxone
#   arm-linux-release
#   arm64-osx-release
#   x86-mingw-static
#   arm64-ios
#   x86-linux
#   x64-xbox-xboxone-static
#   x64-mingw-dynamic
#   x64-uwp-static-md
#   x64-windows-release
#   loongarch32-linux
#   x86-freebsd
#   armv6-android
#   x64-osx-release
#   x64-linux-dynamic
#   riscv64-linux
#   loongarch32-linux-release
#   x86-windows-static
#   mips64-linux
#   arm64ec-windows
#   arm-android
#   arm64-mingw-dynamic
#   arm64-uwp-static-md
#   arm64-osx
#   arm64-windows-static
#   arm-linux
#   arm-windows
#   loongarch64-linux-release
#   x86-mingw-dynamic
#   x86-uwp-static-md
#   arm-uwp-static-md
#   s390x-linux
#   x64-openbsd
#   arm-mingw-dynamic
#   x64-ios
#   x64-xbox-scarlett
#   loongarch64-linux
#   x64-mingw-static
#   arm-ios
#   x64-osx-dynamic
#   x64-linux-release
#   x86-android
#   x86-uwp
#   arm64-linux
#   x64-windows-static-release
#   x64-freebsd
#   arm64-linux-release
#   riscv64-linux-release
#   arm64-windows-static-md
#   arm64-mingw-static
#   x86-windows-static-md
#   arm-mingw-static
#   riscv32-linux-release
#   arm64-osx-dynamic
#   riscv32-linux
#   x86-ios
#   x64-windows-static-md
#   arm64-windows-static-release
#   arm-windows-static
#   s390x-linux-release
#   ppc64le-linux-release
#   x86-windows-v120
#   arm-uwp

def _host_info_to_arch() -> str:
    if host_info().arch.is_aarch64:
        return "arm64"
    if host_info().arch.is_arm:
        return "arm"
    if host_info().arch.is_armeb:
        return "armeb"
    if host_info().arch.is_i386:
        return "x86"
    if host_info().arch.is_mips:
        return "mips"
    if host_info().arch.is_mips64:
        return "mips64"
    if host_info().arch.is_mipsel:
        return "mipsel"
    if host_info().arch.is_mipsel64:
        return "mipsel64"
    if host_info().arch.is_powerpc:
        return "ppc"
    if host_info().arch.is_ppc64:
        return "ppc64"
    if host_info().arch.is_x86_64:
        return "x64"
    if host_info().arch.is_unknown:
        return "x64"

    return "x64"


def _host_info_to_os() -> str:
    if host_info().os.is_linux:
        return "linux"
    if host_info().os.is_macos:
        return "osx"
    if host_info().os.is_windows:
        return "windows"
    if host_info().os.is_freebsd:
        return "freebsd"
    if host_info().os.is_unknown:
        return "windows"

    return "windows"

def _current_triplet():
    return "{}-{}-release".format(_host_info_to_arch(), _host_info_to_os())

def _install_vcpkgs_impl(ctx: AnalysisContext)  -> list[Provider]:
    output = ctx.actions.declare_output("vcpkg", dir=True)
    cmd = cmd_args([ctx.attrs._run_vcpkg[RunInfo]])
    cmd.add("-d")
    cmd.add(ctx.attrs.dir)
    cmd.add("-o")
    cmd.add(output.as_output())
    cmd.add("-t")
    cmd.add(ctx.attrs.triple)
    cmd.add("-c")
    cmd.add(ctx.attrs.c_compiler)
    cmd.add("-x")
    cmd.add(ctx.attrs.cxx_compiler)
    cmd.add(ctx.attrs.manifest)

    ctx.actions.run(cmd, category="run_vcpkg")

    return [DefaultInfo(default_output=output)]

install_vcpkgs = rule(impl = _install_vcpkgs_impl,
    attrs = {
        "dir": attrs.source(),
        "manifest": attrs.string(),
        "c_compiler": attrs.string(),
        "cxx_compiler": attrs.string(),
        "triple":  attrs.string(default = _current_triplet()),
        "_run_vcpkg": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default="//buck2_vcpkg:run_vcpkg"))
    }
)
