#!/bin/bash
# file to setup documentation building pipeline without docker
# $1 : Path to the doc-builder folder relative to the ivy/docs folder

# install libraries for the doc-builder
cat $1/requirements.txt | xargs -n 1 pip install;

# install libraries for ivy
pip install -r ../requirements.txt

# syncing ivy folder with the doc-builder folder
rsync -rav $1/docs/ .

# Delete any previously generated content
rm -rf autogenerated_source

# delete any previously generated pages
rm -rf build

# generate content
python generate_src_rst_files.py  --root_dir ../ivy

# generate pages from content
python sphinx-build.py -Q -b html autogenerated_source build

find build/_images -type f -name "*[0-9].png" -delete
python correct_built_html_files.py

# delete the code
bash ./remove_files.sh
rm -rf remove_files.sh
