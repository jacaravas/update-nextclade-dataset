#!/usr/bin/env python

### Written by Jason Caravas
### Identify most recent sars-cov-2 build

import os, sys, re, json, argparse

def main(arguments):
    parser = argparse.ArgumentParser(description='Extract latest version for dataset')
    parser.add_argument('-n','--name',type=str,help='Dataset name')
    args = parser.parse_args()
    
    desiredDatasetName = args.name
    
    baseUrl = "https://data.clades.nextstrain.org"
    
    jsonString = ""
    for line in sys.stdin:
        jsonString += line

    index = json.loads(jsonString)

    for target in index["datasets"]:
        name = target["name"]
        if name == desiredDatasetName:
            for datasetRefs in target["datasetRefs"]:
                for version in datasetRefs["versions"]:
                    if version["latest"]:
                        tag = version["tag"]
                        reference = target["defaultRef"]
                        versionUrl = baseUrl + "/datasets/" + desiredDatasetName + "/references/" + reference + "/versions/" + tag+ "/files"
                        print (versionUrl)
                        sys.exit(0)
    
if __name__=='__main__':
        main(sys.argv[1:])
