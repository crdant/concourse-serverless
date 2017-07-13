#!/bin/sh
inputDir=  outputDir=

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

package=`find $inputDir -name "*-${stage}-*.tgz"`
tar -C ${outputDir} -xzf ${package}
