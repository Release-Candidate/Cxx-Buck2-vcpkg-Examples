def _build_vcpkg_exe(ctx: AnalysisContext)  -> list[Provider]:
    output = ctx.actions.declare_output("run_vcpkg.log")
    cmd = cmd_args([ctx.attrs._run_vcpkg[RunInfo]])
    cmd.add("-d")
    cmd.add(ctx.attrs.dir)
    cmd.add("-l")
    cmd.add(output.as_output())
    cmd.add("-t")
    cmd.add(ctx.attrs.triple)
    cmd.add(ctx.attrs.manifest)

    ctx.actions.run(cmd, category="run_vcpkg")

    return [DefaultInfo(default_output=output)]

build_vcpkg_exe = rule(impl = _build_vcpkg_exe,
    attrs = {
        "dir": attrs.source(),
        "manifest": attrs.string(),
        "triple": attrs.string(),
        "_run_vcpkg": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default="//buck2_vcpkg:run_vcpkg"))
    }
)
