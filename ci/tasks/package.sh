#!/bin/sh
baseName=${base_name}
inputDir=  outputDir=  versionFile=

export AWS_ACCESS_KEY_ID=${aws_access_key_id}
export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

while [ $# -gt 0 ]; do
  case $1 in
    -i | --input-dir )
      inputDir=$2
      shift
      ;;
    -o | --output-dir )
      outputDir=$2
      shift
      ;;
    -v | --version-file )
      versionFile=$2
      shift
      ;;
    * )
      echo "Unrecognized option: $1" 1>&2
      exit 1
      ;;
  esac
  shift
done

error_and_exit() {
  echo $1 >&2
  exit 1
}

if [ ! -d "$inputDir" ]; then
  error_and_exit "missing input directory: $inputDir"
fi
if [ ! -d "$outputDir" ]; then
  error_and_exit "missing output directory: $outputDir"
fi
if [ ! -f "$versionFile" ]; then
  error_and_exit "missing version file: $versionFile"
fi
if [ -z "$baseName" ]; then
  error_and_exit "missing base file name: $baseName"
fi

version=`cat $versionFile`

npm install -g serverless

workingDir=`pwd`
cd $inputDir
serverless package --package "${workingDir}/${baseName}"
cd $workingDir
tar -czf ${outputDir}/${baseName}-${version}.tgz ${baseName}

echo "Listing: "
ls -l ${outputDir}/${baseName}-${version}.tgz
echo "Contents: "
tar -tzf ${outputDir}/${baseName}-${version}.tgz
exit -1
