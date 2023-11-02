def _concat_compile_cmds_impl(ctx):
    output = ctx.actions.declare_output('compile_commands.log')

    cmd = [ctx.attrs._concat_compile_cmds[RunInfo]]
    cmd.extend(ctx.attrs.files)
    cmd.append(cmd_args(output.as_output(), format="--log={}"))

    ctx.actions.run(
        cmd,
        category="concat_compile_commands",
    )

    return [DefaultInfo(default_output=output)]

concat_compile_cmds = rule(
    impl = _concat_compile_cmds_impl,
    attrs = {
        "files": attrs.list(attrs.source()),
        "_concat_compile_cmds": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default="//concat_compile_cmds:concat_compile_cmds"))
    }
)
