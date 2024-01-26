#!/bin/bash
cd ..
mkdir -p build
mkdir -p archive
# rm -fr build/23xi-data-pipeline

cp -fr kda-pyflink-starter-data-pipeline build/kda-pyflink-starter-data-pipeline
cd build

filename="KdaPyFlinkStarterDataPipeline_V"
version=$(find . -name 'KdaPyFlinkStarterDataPipeline_V*' | sed -e 's/^\.\///' | sed s/$filename// | sed 's/.zip//')
echo $version
if ["$version" == ""] #check if version is null or no file available
then
    version=0
else
    mv $filename$version".zip" ../archive
fi

version=$((version + 1))
echo $version
new_filename=$filename$version".zip"
echo $new_filename

cd kda-pyflink-starter-data-pipeline

rm -rf .git
rm -rf .idea
find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
mv process  dependencies
mv utils dependencies
mv serialization dependencies
mv models dependencies
mv sink dependencies
cd ..
zip -r $new_filename kda-pyflink-starter-data-pipeline
pwd
echo $S3_BUCKET
echo $KEY
echo "s3://$S3_BUCKET/$KEY/$new_filename"
aws s3 cp $new_filename s3://$S3_BUCKET/$KEY/$new_filename
rm -fr kda-pyflink-starter-data-pipeline