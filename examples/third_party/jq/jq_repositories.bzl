"""A module defining the third party dependency zlib"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def jq_repositories():
    maybe(
        http_archive,
        name = "jq",
        build_file = Label("//jq:BUILD.jq.bazel"),
        sha256 = "5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72",
        strip_prefix = "jq-1.6",
        urls = [
            "https://github.com/jqlang/jq/releases/download/jq-1.6/jq-1.6.tar.gz",
        ],
    )
