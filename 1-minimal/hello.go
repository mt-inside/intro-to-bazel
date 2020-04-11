package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Println("hello " + runtime.Version())
}
