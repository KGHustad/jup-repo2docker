# Recipe for singleuser Docker image in JupyterHub

## Directory structure
`binder/` is the directory where repo2docker looks for specification/requirement files. These files are generated from template files located in `binder/src/`.

### Conda packages
The list of conda packages is generated from concatenating the files in `binder/src/conda_packages.d/`. Within that directory, there is one file for each course, and additionally there is `core.txt` where the JupyterHub version is specified, and `base.txt` with the some of the most commonly used packages for scientific computing with Python.

## Usage
To generate spec files with requirements (this will create a conda env and install all required packages there, so it may take some time)
```
make spec
```

To build the Docker image
```
make image
```
