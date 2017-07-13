#!/bin/sh
baseName=${base_name}
inputDir=  outputDir=  versionFile=

env

echo "was stage passed? "
if [[ -n "${stage}" ]] ; then
  echo "Yes: ${stage}"
else
  echo "No"
fi

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

workingDir=`pwd`
cd $inputDir
echo serverless package --package "${workingDir}/${baseName}" --stage "${stage}"
serverless package --package "${workingDir}/${baseName}" --stage "${stage}"
cd $workingDir
echo tar -czf ${outputDir}/${baseName}-${stage}-${version}.tgz ${baseName}
tar -czf ${outputDir}/${baseName}-${stage}-${version}.tgz ${baseName}
