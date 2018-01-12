workspace(name = "build_bazel_eclipse")

git_repository(
    name = "bazel_skylib",
    remote = "https://github.com/bazelbuild/bazel-skylib",
    commit = "2169ae1c374aab4a09aa90e65efe1a3aad4e279b",
)

load("@bazel_skylib//:lib.bzl", "versions")
versions.check("0.5.0")

# TODO(dmarting): switch to release version of integration testing
http_archive(
    name = "build_bazel_integration_testing",
    url = "https://github.com/bazelbuild/bazel-integration-testing/archive/55a6a70dbcc2cc7699ee715746fb1452788f8d3c.zip",
    sha256 = "b505866c12b9f6ce08b96a16305407deae43bef7655a8e7c2197d08c24c6cb04",
    strip_prefix = "bazel-integration-testing-55a6a70dbcc2cc7699ee715746fb1452788f8d3c",
)

load("@build_bazel_integration_testing//tools:bazel_java_integration_test.bzl", "bazel_java_integration_test_deps")
bazel_java_integration_test_deps()

load("//tools/build_defs:eclipse.bzl", "load_eclipse_deps")
load_eclipse_deps()

new_http_archive(
    name = "com_google_python_gflags",
    url = "https://github.com/google/python-gflags/archive/python-gflags-2.0.zip",
    strip_prefix = "python-gflags-python-gflags-2.0",
    build_file_content = """
py_library(
    name = "gflags",
    srcs = [
        "gflags.py",
        "gflags_validators.py",
    ],
    visibility = ["//visibility:public"],
)
""",
    sha256 = "344990e63d49b9b7a829aec37d5981d558fea12879f673ee7d25d2a109eb30ce",
)

# TODO(dmarting): Use http_file and relies on a mirror instead of maven_jar
maven_jar(
    name = "org_json",
    artifact = "org.json:json:jar:20160212",
)

maven_jar(
    name = "com_google_truth",
    artifact = "com.google.truth:truth:jar:0.31",
)
