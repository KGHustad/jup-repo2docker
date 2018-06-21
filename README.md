# Recipe for singleuser Docker image in JupyterHub

## Directory structure
`binder/` is the directory where repo2docker looks for specification/requirement files. These files are generated from template files located in `binder/src/`.

### Conda packages
The list of conda packages is generated from concatenating the files in `binder/src/conda_packages.d/`. Within that directory, there is one file for each course, and additionally there is `core.txt` where the JupyterHub version is specified, and `base.txt` with the some of the most commonly used packages for scientific computing with Python.
__NB: Duplicate packages are removed with `uniq` (duplicate packages should result in identical lines in the concatenated file). There could be version constraints like "numpy<=1.14", and "numpy>=1.12", which conda is able to handle.__

## Environment variables
Environment variables for the image can be specified in `environment_variables.txt` (one variable per line).
We set `OMP_NUM_THREADS=1` since we are aiming to maximise QoS for a potentially large number of users. (Some libraries used by numpy and scipy are OpenMP-enabled.)

## Usage
To generate spec files with requirements (this will create a conda env and install all required packages there, so it may take some time)
```
make spec
```

To build the Docker image
```
make image
```

Note that the default command set in the Dockerfile is `jupyter notebook --ip 0.0.0.0`. We want to run our own bash script to copy in new files and check for maintenance. This script is located in `binder/jupyterhub-uio.sh` and is copied into a directory on the user's PATH. This should allow us to run the docker image with the command `./jupyterhub-uio.sh`
