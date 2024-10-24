# DevTools
A collection of helpful command-line tools for developers to automate common tasks.

## 🛠 Tools Included

### quickproject 
This script automates the setup of a new Python project with Pipenv in Visual Studio Code, including environment management, project structure, and essential configuration files.
```bash
quickproject
```

### setvsenv
This script sets the Python interpreter for Visual Studio Code based on the active Pipenv virtual environment. It checks for Pipenv installation, retrieves the virtual environment's path, and updates the VS Code settings accordingly.
```bash
setvsenv
```


### imgconvert
This script automates the conversion of image files from one format to another using ffmpeg. It prompts the user for the original file type and the desired output file type, then processes all matching files in the current directory.
```bash
imgconvert
```

### gitsetup
Initializes a Git repository with custom configurations. It will ask for files to add to staging, rename main branch to master, and ask for project name to create an initial commit. 
```bash
gitsetup
```

### djangoreact
This script automates the setup of a full-stack project, supporting either a backend (Django), a frontend (React with Vite), or both. It checks for necessary dependencies, creates project directories, and initializes the chosen frameworks.
```bash
djangoreact
```

## 🚀 Installation
Clone this repository:
```bash
git clone https://github.com/WaryaWayne/dev-tools.git
cd devtools
```

## Run the installer:
This script installs a set of development tools by copying scripts to a designated directory, creating symbolic links for easy access, and updating the user's PATH.
```bash
./install.sh
```

## 🗑 Uninstallation
This script removes the installed development tools, including deleting scripts and symbolic links, and cleaning up PATH settings.
```bash
./uninstall.sh
```

## ⚙️ Requirements
- Bash or ZSH shell
- Pipenv
- Visual Studio Code
- Git
- FFmpeg (for image conversion)

## 📝 License
This project is licensed under the MIT License. See the LICENSE file for details. The MIT License allows you to freely use, modify, and distribute this project.
