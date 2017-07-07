#!/bin/sh

inputDir=  outputDir=  versionFile= service=

AWS_ACCESS_KEY_ID=$aws-access-key-id
AWS_SECRET_ACCESS_KEY=$aws-secret-access-key
AWS_REGION=$aws-region
TWILIO_AUTH_TOKEN=$twillio-auth-token
TWILIO_ACCOUNT_SID=$twillio-account-sid

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

version=`cat $versionFile`

cd $inputDir
npm install

echo Packaging service...
node ./node_modules/serverless/bin/serverless package --package ${outputDir}
package=`find ${outputDir} -name '*.zip'`
service=`basename ${package} | cut  -f 1 -d '.'`

mv ${outputDir}/${service}.zip ${outputDir}/${service}-${version}.zip
