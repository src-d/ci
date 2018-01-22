package main

import (
	"github.com/src-d/ci/examples/basic"
)

var (
	version string
	build   string
	commit  string
)

func main() {
	basic.HelloWorld(version, build, commit)
}
