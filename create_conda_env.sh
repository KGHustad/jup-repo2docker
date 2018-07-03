set -x
CONDA_ENV_NAME=jup
CONDA_ENV_FILE=binder/environment.yml
CONDA_PACKAGE_LIST=binder/conda_packages.txt
set +x

# exit on non-zero return code
set -e

conda create --yes --name ${CONDA_ENV_NAME} python=3.6
source activate ${CONDA_ENV_NAME}

conda config --prepend channels conda-forge
conda install --yes --file ${CONDA_PACKAGE_LIST}

# remove pyqt and qt
conda remove --quiet --yes --force qt pyqt

conda env export | ./strip_pip.py > ${CONDA_ENV_FILE}

## append pip packages to file
cat environment_pipsuffix.yml >> ${CONDA_ENV_FILE}

source deactivate
conda env remove --yes --name ${CONDA_ENV_NAME}

# remove name and prefix keys from environment.yml

sed -i '/name:/d' ${CONDA_ENV_FILE}
sed -i '/prefix:/d' ${CONDA_ENV_FILE}
