.PHONY: spec image

IMAGE_NAME = jup/singleuser-uio
IMAGE_TAG = $(shell git rev-parse --short HEAD)

spec_files = binder/apt.txt binder/environment.yml

spec: $(spec_files)

binder/apt.txt: binder/src/apt.txt
	cat $< | ./apt_preprocess.py > $@

binder/conda_packages.txt: $(wildcard binder/src/conda_packages.d/*.txt)
	cat $^ | sort | uniq > $@

binder/environment.yml: binder/conda_packages.txt
	./create_conda_env.sh


image:
	jupyter-repo2docker --image_name $(IMAGE_NAME):$(IMAGE_TAG) binder/
