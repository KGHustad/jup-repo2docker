#!/bin/bash

set -x
CONDA_ENV_NAME=jup
CONDA_ENV_FILE=binder/environment.yml
CONDA_PACKAGE_LIST=binder/conda_packages.txt
EXTRA_CHANNELS_LIST=binder/conda_extra_channels.txt
set +x

# exit on non-zero return code
set -e

# use a local .condarc file
echo -e "channels:\n  - defaults" > .condarc
export CONDARC=$(realpath .condarc)

conda create --yes --name ${CONDA_ENV_NAME} python=3.6
source activate ${CONDA_ENV_NAME}

conda config --file ${LOCAL_CONDARC} --prepend channels conda-forge

while read extra_channel; do
    echo "Appending ${extra_channel} to channel list"
    conda config --file ${LOCAL_CONDARC} --append channels ${extra_channel}
done < ${EXTRA_CHANNELS_LIST}

# use mirrors if configured in conda_mirror.json
./use_conda_mirror.py

conda config --show channels

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
