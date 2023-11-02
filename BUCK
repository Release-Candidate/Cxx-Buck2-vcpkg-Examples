load("//concat_compile_cmds:defs.bzl", "concat_compile_cmds")


concat_compile_cmds(
    name="compile_commands",
    files=[
        "//app:app[full-compilation-database]",
        "//lib:library[full-compilation-database]",
        "//test:test[full-compilation-database]",
    ],
)

alias(
    name="exe",
    actual="//app:app",
    visibility=["PUBLIC"],
)

alias(
    name="lib",
    actual="//lib:library",
    visibility=["PUBLIC"],
)

alias(
    name="test",
    actual="//test:test",
    visibility=["PUBLIC"],
)
