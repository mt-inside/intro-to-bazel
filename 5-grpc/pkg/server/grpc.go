package server

import (
	"context"
	"net"

	pb "github.com/mt165/intro-to-bazel/api"
	"google.golang.org/grpc"
)

type Hello struct{}

func (h Hello) SayHello(ctxt context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	return &pb.HelloReply{Message: "hello gRPC"}, nil
}

func ServeGrpc() {
	sock, _ := net.Listen("tcp", ":50051")

	srv := grpc.NewServer()
	pb.RegisterHelloServer(srv, &Hello{})

	srv.Serve(sock)
}
