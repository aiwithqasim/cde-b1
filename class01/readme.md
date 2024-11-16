# Python Setup Guide with VS Code, Virtual Environments, and Anaconda

This guide provides a step-by-step approach to setting up Python for Visual Studio Code (VS Code), working with virtual environments using `venv` and `conda`, and setting up Jupyter Notebook.

## Table of Contents

- [Part 1: Setting Up Python for VS Code](#part-1-setting-up-python-for-vs-code)
  - [Step 1: Download and Install Python](#step-1-download-and-install-python)
  - [Step 2: Install Visual Studio Code](#step-2-install-visual-studio-code)
  - [Step 3: Install Python Extension for VS Code](#step-3-install-python-extension-for-vs-code)
- [Part 2: Understanding Virtual Environments](#part-2-understanding-virtual-environments)
  - [What are Virtual Environments?](#what-are-virtual-environments)
  - [How to Create and Use `venv`](#how-to-create-and-use-venv)
- [Part 3: Setting Up Anaconda and Jupyter Notebook](#part-3-setting-up-anaconda-and-jupyter-notebook)
  - [Step 1: Download and Install Anaconda](#step-1-download-and-install-anaconda)
  - [Step 2: Setting Up Jupyter Notebook](#step-2-setting-up-jupyter-notebook)
  - [How to Create and Use Virtual Environments with `conda`](#how-to-create-and-use-virtual-environments-with-conda)

---

## Part 1: Setting Up Python for VS Code

### Step 1: Download and Install Python

1. Go to the official [Python website](https://www.python.org/downloads/release/python-3117/).
2. Download the latest version of Python for your operating system.
3. Run the installer and **make sure to check the box "Add Python to PATH"**.
4. Complete the installation process.

To verify your installation, open a terminal (Command Prompt, PowerShell, or Terminal) and run:

```bash
python --version
```

### Step 2: Install Visual Studio Code

1. Download and install [Visual Studio Code (VS Code)](https://code.visualstudio.com/).
2. Launch VS Code after installation.

### Step 3: Install Python Extension for VS Code

1. Open VS Code.
2. Go to the **Extensions** view by clicking on the square icon in the sidebar or pressing `Ctrl+Shift+X` (`Cmd+Shift+X` on macOS).
3. Search for the **Python** extension and install it (developed by Microsoft).

To verify the Python installation in VS Code:

1. Open a new terminal within VS Code (`Ctrl+``).
2. Type:
   ```bash
   python --version
   ```

---

## Part 2: Understanding Virtual Environments

### What are Virtual Environments?

Virtual environments in Python are isolated environments that allow you to manage dependencies for different projects separately. This prevents conflicts between package versions across different projects.

### How to Create and Use `venv`

1. **Create a Virtual Environment**:

   ```bash
   python -m venv myenv
   ```

   - Replace `myenv` with your preferred environment name.

2. **Activate the Virtual Environment**:

   - On **Windows**:
     ```bash
     myenv\Scripts\activate
     ```
   - On **macOS/Linux**:
     ```bash
     source myenv/bin/activate
     ```

3. **Deactivate the Virtual Environment**:

   ```bash
   deactivate
   ```

4. **Install Packages in the Virtual Environment**:

   ```bash
   pip install <package-name>
   ```

5. **List Installed Packages**:

   ```bash
   pip list
   ```

6. **Remove the Virtual Environment** (optional):
   Simply delete the folder:
   ```bash
   rm -rf myenv
   ```

---

## Part 3: Setting Up Anaconda and Jupyter Notebook

### Step 1: Download and Install Anaconda

1. Download the Anaconda distribution from the [official website](https://www.anaconda.com/download/success).
2. Run the installer and follow the on-screen instructions.
3. To verify the installation, open a terminal and type:
   ```bash
   conda --version
   ```

### Step 2: Setting Up Jupyter Notebook

1. Open the Anaconda Prompt (Windows) or a terminal (macOS/Linux).
2. Install Jupyter Notebook if not already installed:
   ```bash
   conda install jupyter
   ```
3. Launch Jupyter Notebook:
   ```bash
   jupyter notebook
   ```
   - This will open the Jupyter Notebook interface in your default web browser.

### How to Create and Use Virtual Environments with `conda`

1. **Create a Virtual Environment**:

   ```bash
   conda create --name myenv
   ```

   - Replace `myenv` with your preferred environment name.
   - You can specify the Python version by just adding python version after environment name (e.g., `conda create --name myenv python=3.9`).

2. **Activate the Virtual Environment**:

   ```bash
   conda activate myenv
   ```

3. **Deactivate the Virtual Environment**:

   ```bash
   conda deactivate
   ```

4. **Install Packages in the Conda Environment**:

   ```bash
   conda install <package-name>
   ```

5. **List Installed Packages**:

   ```bash
   conda list
   ```

6. **Create an Environment with Specific Packages**:

   ```bash
   conda create --name dataenv numpy pandas matplotlib
   ```

7. **Remove a Conda Environment**:
   ```bash
   conda remove --name myenv --all
   ```

---

## Additional Tips

- To set your preferred Python interpreter in VS Code, use the `Python: Select Interpreter`.
- It's a good practice to create a `.gitignore` file to exclude your virtual environment folder (e.g., `myenv/` or `env/`) from version control.
- Use `requirements.txt` or `environment.yml` to share dependencies for reproducibility.

### How to Export and Import Dependencies

- **For `venv`**:
  ```bash
  pip freeze > requirements.txt
  pip install -r requirements.txt
  ```
- **For `conda`**:
  ```bash
  conda env export > environment.yml
  conda env create -f environment.yml
  ```

---

Happy learning!

---
