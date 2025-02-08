### Conda Environment

Requirement: You must have Anaconda Installed in you system.

- To create an environment: ``conda create --name myenv``
- When conda asks you to proceed, type ``y``: **proceed ([y]/n)**?
- To create an environment with a specific version of Python: ``conda create -n myenv python=3.6``
- To create an environment with a specific package: ``conda create -n myenv scipy`` OR ``conda create -n myenv python`` OR ``conda install -n myenv scipy``
- To create an environment with a specific version of a package: ``conda create -n myenv scipy=0.15.0`` OR ``conda create -n myenv python`` OR ``conda install -n myenv scipy=0.15.0``
- To create an environment with a specific version of Python and multiple packages: ``conda create -n myenv python=3.6 scipy=0.15.0``
- Create the environment from the ``environment.yml`` file: ``conda env create -f environment.yml``
- Activate the new environment: ``conda activate myenv``
- Verify that the new environment was installed correctly: ``conda env list`` OR ``conda info --envs``
- To deactivate Environment: ``conda deactivate``
- To reomve Enviroment: ``conda remove -- name my_env --all``
-  To make requirement file: ``conda freeze > requirements.txt``
-[For More details](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#activating-an-environment)


### Virtual Environment

To install virtual environment : ``pip install virtualenv``

- virtualenv project_name
- source project_name/bin/activate
- clear
- ls
- source project_name/Scripts/activate
- which python
- which pip
- pip list
- pip install numpy
- pip install pandas
- pip install --upgrade pip
- pip install numpy
- pip install pandas
- pip install matplotlib
- python --version
- pip freeze --local > requirement.txt
- ls
- cat requirement.txt
- deactivate
- which python
- which pip
- pip list
- rm -rf project_name/
- ls
- virtualenv project_name -p python3
- source project_name/Scripts/activate
- pip list
- pip install -r requiremnet.txt
- pip list
- deactivate
