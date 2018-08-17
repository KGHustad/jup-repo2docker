.PHONY: spec image

IMAGE_NAME = jup/singleuser-uio
IMAGE_TAG = $(shell git rev-parse --short HEAD)
IMAGE_USER = jupyter

env_variables = $(subst \n, ,$(shell cat environment_variables.txt))
env_variables_args = $(foreach env_var,$(env_variables),--env $(env_var))

spec_files = binder/apt.txt binder/environment.yml

spec: $(spec_files)

binder/apt.txt: binder/src/apt.txt apt_preprocess.py
	cat $< | ./apt_preprocess.py > $@

binder/conda_packages.txt binder/conda_extra_channels.txt: $(wildcard binder/src/conda_packages.d/*.txt)
	#cat $^ | sort | uniq > $@
	cat $^ | ./process_conda_requirements.py

binder/environment.yml: create_conda_env.sh binder/conda_packages.txt environment_pipsuffix.yml strip_pip.py
	./create_conda_env.sh

image:
	jupyter-repo2docker --user-name $(IMAGE_USER) --user-id 1000 --image-name $(IMAGE_NAME):$(IMAGE_TAG) --no-run binder/
image-run:
	jupyter-repo2docker --user-name $(IMAGE_USER) --user-id 1000 --image-name $(IMAGE_NAME):$(IMAGE_TAG) binder/

# Dump Dockerfile to stderr
image-debug:
	jupyter-repo2docker --debug --no-build --user-name $(IMAGE_USER) --user-id 1000 binder/
