dvc get https://github.com/iterative/dataset-registry tutorials/versioning/data.zip
unzip data.zip
rm -f data.zip

echo "filename" > images.csv
find data -type f -iname "*.jpg" | sed 's|^data/||' | sort >> images.csv

wc -l images.csv

git init
dvc init
dvc remote add -d myremote s3://aiops-da24b030-dvcstore
dvc add data
git add .
git commit -m "version-1"
dvc push
git tag -a "v1.0" -m "added the images version 1"











dvc import https://github.com/iterative/dataset-registry tutorials/versioning/new-labels.zip
git add new-labels.zip.dvc .gitignore
git commit -m "Import new-labels.zip via dvc import"

unzip new-labels.zip
rm -f new-labels.zip

dvc add data/

echo "filename" > images.csv
find data -type f -iname "*.jpg" | sed 's|^data/||' | sort >> images.csv
wc -l images.csv

git add data.dvc images.csv
git commit -m "v2: added new-labels images, dataset now has 2801 images"

dvc push

git tag -a "v2.0" -m "csv now has 2801 images"











wc -l images.csv

git checkout v1.0
dvc checkout

wc -l images.csv
find data -type f -iname "*.jpg" | wc -l