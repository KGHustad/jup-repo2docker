.PHONY: spec image

IMAGE_NAME = jup/singleuser-uio
IMAGE_TAG = $(shell git rev-parse --short HEAD)

env_variables = $(subst \n, ,$(shell cat environment_variables.txt))
env_variables_args = $(foreach env_var,$(env_variables),--env $(env_var))

spec_files = binder/apt.txt binder/environment.yml

spec: $(spec_files)

binder/apt.txt: binder/src/apt.txt
	cat $< | ./apt_preprocess.py > $@

binder/conda_packages.txt: $(wildcard binder/src/conda_packages.d/*.txt)
	cat $^ | sort | uniq > $@

binder/environment.yml: binder/conda_packages.txt
	./create_conda_env.sh

image:
	jupyter-repo2docker --image-name $(IMAGE_NAME):$(IMAGE_TAG) $(env_variables_args) binder/
