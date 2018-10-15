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
LOCAL_CONDARC=$(realpath .condarc)
export CONDARC=${LOCAL_CONDARC}

# clear/remove .condarc if it exists
[ -f "$LOCAL_CONDARC" ] && rm $LOCAL_CONDARC          

# add and configure channels
conda config --file ${LOCAL_CONDARC} --prepend channels conda-forge

while read extra_channel; do
    echo "Appending ${extra_channel} to channel list"
    conda config --file ${LOCAL_CONDARC} --append channels ${extra_channel}
done < ${EXTRA_CHANNELS_LIST}

# use mirrors if configured in conda_mirror.json
./use_conda_mirror.py

conda config --show channels

# patch jupyter-repo2docker miniconda-installation to use the same channels
INSTALLER=~/.local/lib/python3.6/site-packages/repo2docker/buildpacks/conda/install-miniconda.bash
SHA256="8aaeda9e0a3a806037cd9b08e4bc3aca6e1a8e143690fa3ae3a7d44835cfa03f"

if [ -f "$INSTALLER" ]
then
  if echo "$SHA256 $INSTALLER" | sha256sum --quiet -c
  then
    echo "Patching $INSTALLER"
    conda config --show channels | grep '  - ' | sed 's/  - /conda config --system --add channels /' > /tmp/conda-channels
    sed -i "/conda config --system --add channels conda-forge/{r /tmp/conda-channels
    d;};" ~/.local/lib/python3.6/site-packages/repo2docker/buildpacks/conda/install-miniconda.bash
    rm /tmp/conda-channels
  else
    printf "\033[1;33m%s\033[0m\n" "I won't patch $INSTALLER. The checksum is wrong"
  fi
else
  printf "\033[1;33m%s\033[0m\n" "I can't patch $INSTALLER. The file is not there"
fi

# create and install environment
conda create --yes --name ${CONDA_ENV_NAME}
source activate ${CONDA_ENV_NAME}

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
