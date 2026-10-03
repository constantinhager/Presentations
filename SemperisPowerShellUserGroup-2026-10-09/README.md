# psconfeu2026-VSCodeEveryWhere
Session Material for PSConf EU 2026 Session: VSCode everywhere: Set Up Once, Use Anywhere

# .devcontainer
This folder contains the configuration files for the development container. The `devcontainer.json` file defines the settings for the container, such as the image to use, any features or extensions to include, and any post-create commands to run.
Use this as standard for your repositories to ensure that you have a consistent development environment across all your projects.

This is used for showing the Codespaces demo, but you can also use it for local development with the Remote Containers extension in VS Code.

# 1.BuildDockerFileVSCode
Open Command Palette (Ctrl+Shift+P) and select "Dev Containers: Create Dev Container Configuration Files..." and choose "Python 3" as the base image. This will create a `.devcontainer` folder with a `Dockerfile` and `devcontainer.json` file.

Normally you should leave the .devcontainer folder in the root of your project, but for the sake of this session, we will move it to a separate folder.

Go over the devcontainer.json file and explain the settings, such as the name of the container, the image to use, and any extensions or settings you want to include.

Waring: Do not use this devcontainer.json file for production use, as the powershell team has deprecated that container.
They are not doing extra docker containers for powershell anymore, and the one that is there is not being updated.
Use the official Microsoft .net container Images instead.

# 2.OfficialDotNetContainers

Microsoft has official .net containers that you can use for your development. You can find them on the Microsoft Container Registry (MCR) at [.net SDK Containers](https://mcr.microsoft.com/artifact/mar/dotnet/sdk/about). These also include powershell, so you can use them for your development.

.devcontainer/devcontainer.json
```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the
// README at: https://github.com/devcontainers/templates/tree/main/src/powershell
{
	"name": "PowerShell",
	// Or use a Dockerfile or Docker Compose file. More info: https://containers.dev/guide/dockerfile
	"image": "mcr.microsoft.com/dotnet/sdk:10.0",
	"features": {

	},

	// Configure tool-specific properties.
	"customizations": {
		// Configure properties specific to VS Code.
		"vscode": {

		}
	}

	// Use 'forwardPorts' to make a list of ports inside the container available locally.
	// "forwardPorts": [],

	// Uncomment to connect as root instead. More info: https://aka.ms/dev-containers-non-root.
	// "remoteUser": "root"
}
```

# Sample Repositories for Devcontainers

https://github.com/devcontainers/templates
https://github.com/dataplat/dbatools/tree/development/.devcontainer
https://github.com/dataplat/dbachecks/tree/main/.devcontainer
https://github.com/constantinhager/psconfeu2024-PSU/tree/main/projects
