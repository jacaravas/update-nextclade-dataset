#!/bin/bash

## J. Caravas with S. Shepard

##  This script automates the nextclade update process

index_url="https://data.clades.nextstrain.org/index.json"
data_files=("genemap.gff" "primers.csv" "qc.json" "reference.fasta" "sequences.fasta" "tag.json" "tree.json" "virus_properties.json")

set -xo

while getopts n:o: flag
do
    case "${flag}" in
        n) name=${OPTARG};;
        o) outputdir=${OPTARG};;
    esac
done

function check_status (){
    exit_status=$?
    if [[ $exit_status != 0 ]]; then
        fatal_error
    fi
}

function fatal_error () {
    echo -e "Failed at $STAGE.  Terminating"
    exit 1
}

STAGE="DOWNLOAD INDEX"
## To specify a certificate file, you can alter this command to "file_base_url=$(curl -v --cacert <CERTIFICATE FILE> $index_url | zcat | workflow/snakemake_rules/parse_index.py --name $name)"
file_base_url=$(curl -v $index_url | zcat | workflow/snakemake_rules/parse_index.py --name $name)
check_status
echo "Base URL = $file_base_url"

STAGE="DOWNLOAD DATASET"
if [ ! -d $outputdir ]; then
    mkdir $outputdir
fi
for file in "${data_files[@]}"
do
    file_url=$file_base_url/$file
    dest_file=$outputdir/$file
    ## To specify a certificate file, you can alter this command to "curl --cacert <CERTIFICATE FILE> $file_url | zcat > $dest_file"
    curl $file_url | zcat > $dest_file
    check_status
done




