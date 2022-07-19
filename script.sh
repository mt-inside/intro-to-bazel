# ONE - minimal
bazel build .
bazel build //...
bazel run //...
bazel run //:hello
bazel run //:hello # very quick as it doesn't rebuild anything
bazel query 'deps(//:hello)' --output graph > hello.dot && dot -Tpng < hello.dot > hello.png
# don't even have a go.mod, no deps at all

# TWO - dependency
add pkg/server/http.go (package server)
add BUILD.bazel file for that (just go_library, make/keep it private)
bazel build //pkg/server
bazel build //pkg/server:go_default_library
bazel build //pkg/server:*
bazel run //:hello

# THREE - gazelle
add pkg/greeter/name.go (var Name=doxlon)
edit pkg/server/http.go
bazel run //cmd/hello:hello
would be tedious to go through all that stuff again
edit WORKSPACE
edit BUILD # mixing things here cause we shouldn't have go code in /
bazel run //:gazelle
cat pkg/greeter/BUILD.bazel
cat pkg/server/BUILD.bazel # see the deps, that comes from the import
bazel run //cmd/hello:hello

# THREE.FIVE - tests
bazel run //:gazelle
bazel test //...

# FOUR - docker
edit WORKSPACE
edit BUILD.bazel # again, mixing intents. load and target line
bazel run //:gazelle # autogen the boring files I cba to write
docker ps # show that docker's off
bazel build //:hello_image # just builds the tar in the sandbox, doesn't do anything with it
# see it downloading "go_base_image"
start docker
bazel run //:hello_image
we're building on a mac - TODO don't think this is needed now we specify os and arch in the go_image()
bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //:hello_image
# kinda magic runes, but there's clearly a platform flag and that repo of bazel rules we pulled down obviously has some platform definitions in it
docker ps

edit BUILD # add push
bazel run //:hello_push
show docker hub

# FIVE - gRPC
add api/hello.proto
add pkg/server/grpc.go, function ServeGrpc
edit hello.go
bazel run //cmd/hello:hello # doesn't know about the dep
bazel run //:gazelle
bazel run //cmd/hello:hello # now doesn't know about grpc, which is our first external dep
notice that we haven't done a go get or anything
there's a gazelle sub-command to add repos, just like go get adds to go.mod
bazel run //:gazelle -- update-repos google.golang.org/grpc
vim WORKSPACE # can tell it to write to another file. Can use go get in your workflow and tell it to update its repos from a go.mod file
bazel run //cmd/hello:hello # ok, grpc has some deps, and it uniquely annoying actually
go mod init github.com/mt165/intro-to-bazel
go get golang.org/x/net
bazel run //:gazelle -- update-repos -from_file=go.mod
bazel run //cmd/hello:hello # ah yes, and we need to compile protos. This is magic and annoying, and honestly is best c&p'd rather than trial-and-error like this. But at least it knows it has to compile protos, there's no bash / make or generate comments. We're really only being asked to spell out the bits where we need to pin a version, including in this case the proto compiler. Proto/gRPC use is so common in golang that the go rules used to list them as a dependancy (ie that call to go_dependencies used to emit all this stuff we're adding), but there's technical reasons why it can't atm, I think there's a long-term fix coming
edit WORKSPACE # load git_repo, add the com_google_protobuf git_repo, load protobuf_deps from it, run protobuf_deps
vim api/BUILD.bazel
bazel run //cmd/hello:hello
grpcurl -plaintext -format=json -proto=api/hello.proto -d @ localhost:50051 hello.Hello.SayHello <<< {}
bazel query 'deps(//:hello)' --output graph > hello.dot && dot -Tpng < hello.dot > hello.png
