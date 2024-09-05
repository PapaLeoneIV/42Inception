package main

import (
	"fmt"
	"log"
	"os/exec"
	"strings"
)

func executeCommand(command string, args ...string) (string, error) {
	cmd := exec.Command(command, args...)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("command failed: %v, output: %s", err, output)
	}
	return string(output), nil
}

func main() {
	containers, err := executeCommand("docker", "ps", "-aq")
	if err != nil {
		log.Fatalf("Failed to list containers: %v", err)
	}
	containerIDs := strings.Fields(containers)

	if len(containerIDs) == 0 {
		fmt.Println("No containers to stop or remove.")
		return
	}

	_, err = executeCommand("docker", "stop", containerIDs[0])
	if err != nil {
		log.Fatalf("Failed to stop containers: %v", err)
	}
	fmt.Println("All containers stopped successfully.")

	_, err = executeCommand("docker", "rm", containerIDs[0])
	if err != nil {
		log.Fatalf("Failed to remove containers: %v", err)
	}
	fmt.Println("All containers removed successfully.")
}
