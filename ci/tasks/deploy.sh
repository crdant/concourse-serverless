#!/bin/sh

inputDir=

export AWS_ACCESS_KEY_ID=${aws_access_key_id}
export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

while [ $# -gt 0 ]; do
  case $1 in
    -i | --input-dir )
      inputDir=$2
      shift
      ;;
    -i | --source-dir )
      sourceDir=$2
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

package=`find ${inputDir} -name '*.zip'`
echo "Deploying service in ${package}..."
cd ${sourceDir}
node ./node_modules/serverless/bin/serverless deploy --stage ${stage} --package ${package}
