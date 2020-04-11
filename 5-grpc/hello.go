package main

import "github.com/mt165/intro-to-bazel/pkg/server"

func main() {
	go server.Serve()
	go server.ServeGrpc()
	<-make(chan bool)
}
