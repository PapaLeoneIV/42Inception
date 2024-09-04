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

func removeDockerVolumes() {
	volumesOutput, err := executeCommand("docker", "volume", "ls", "-q")
	if err != nil {
		log.Fatalf("Failed to list volumes: %v", err)
	}

	volumes := strings.Fields(volumesOutput)
	if len(volumes) == 0 {
		fmt.Println("No volumes to remove.")
		return
	}

	for _, volume := range volumes {
		_, err := executeCommand("docker", "volume", "rm", volume)
		if err != nil {
			log.Printf("Failed to remove volume %s: %v", volume, err)
		} else {
			fmt.Printf("Removed volume: %s\n", volume)
		}
	}
}

func removeDockerImages() {
	imagesOutput, err := executeCommand("docker", "image", "ls", "-q")
	if err != nil {
		log.Fatalf("Failed to list images: %v", err)
	}

	images := strings.Fields(imagesOutput)
	if len(images) == 0 {
		fmt.Println("No images to remove.")
		return
	}

	for _, image := range images {
		_, err := executeCommand("docker", "image", "rm", image)
		if err != nil {
			log.Printf("Failed to remove image %s: %v", image, err)
		} else {
			fmt.Printf("Removed image: %s\n", image)
		}
	}
}

func main() {
	removeDockerVolumes()
	removeDockerImages()

	fmt.Println("Docker cleanup completed successfully.")
}
