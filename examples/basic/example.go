// Package basic is just an example.
package basic

import (
	"fmt"
)

func HelloWorld(build, version, commit string) {
	fmt.Println("Hello World! Application\n")
	fmt.Println("Build information:")
	fmt.Printf("\tBuild: %s\n\tVersion: %s\n\tCommit: %s\n", build, version, commit)
}
