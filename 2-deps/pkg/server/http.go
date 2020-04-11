package server

import (
	"fmt"
	"net/http"
)

func Serve() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello\n")
	})

	fmt.Println("Listening on :8080...")
	http.ListenAndServe(":8080", nil)
}
