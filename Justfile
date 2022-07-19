default:
	@just --list

reset:
	rm -f [345]*/cmd/hello/BUILD.bazel
	rm -f [345]*/pkg/greeter/BUILD.bazel
	rm -f [345]*/pkg/server/BUILD.bazel
	rm -f [345]*/api/BUILD.bazel
