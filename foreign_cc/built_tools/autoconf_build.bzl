""" Rule for building GNU Make from sources. """

load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load(
    "//foreign_cc/built_tools/private:built_tools_framework.bzl",
    "FOREIGN_CC_BUILT_TOOLS_ATTRS",
    "FOREIGN_CC_BUILT_TOOLS_FRAGMENTS",
    "FOREIGN_CC_BUILT_TOOLS_HOST_FRAGMENTS",
    "absolutize",
    "built_tool_rule_impl",
)
load(
    "//foreign_cc/private:cc_toolchain_util.bzl",
    "get_env_vars",
    "get_flags_info",
    "get_tools_info",
)
load("//foreign_cc/private/framework:platform.bzl", "os_name")
load("//toolchains/native_tools:tool_access.bzl", "get_make_data")

def _autoconf_tool_impl(ctx):
    make_data = get_make_data(ctx)
    script = [
        "./configure --prefix=$$INSTALLDIR$$",
        "%s" % make_data.path,
        "%s install" % make_data.path,
        "sed -i -e 's@args: --prepend-include .*$@args: --prepend-include \\x27\\$\\$EXT_BUILD_ROOT\\$\\$/share/autoconf\\x27@g' $$INSTALLDIR$$/share/autoconf/autom4te.cfg",
    ]

    additional_tools = depset(transitive = [make_data.target.files])

    return built_tool_rule_impl(
        ctx,
        script,
        ctx.actions.declare_directory("autoconf"),
        "BootstrapAutoconf",
        additional_tools,
    )

autoconf_tool = rule(
    doc = "Rule for building autoconf",
    attrs = FOREIGN_CC_BUILT_TOOLS_ATTRS,
    host_fragments = FOREIGN_CC_BUILT_TOOLS_HOST_FRAGMENTS,
    fragments = FOREIGN_CC_BUILT_TOOLS_FRAGMENTS,
    output_to_genfiles = True,
    implementation = _autoconf_tool_impl,
    toolchains = [
        "@rules_foreign_cc//foreign_cc/private/framework:shell_toolchain",
        "@rules_foreign_cc//toolchains:make_toolchain",
        "@bazel_tools//tools/cpp:toolchain_type",
    ],
)
