package server

import (
	"fmt"
	"net/http"

	"github.com/mt165/intro-to-bazel/pkg/greeter"
)

func Serve() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello %s\n", greeter.Name())
	})

	fmt.Println("Listening on :8080...")
	http.ListenAndServe(":8080", nil)
}
