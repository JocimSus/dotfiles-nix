#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.requests python3Packages.dataclasses-json

import json
import requests
import re

VERSIONS_URL = "https://downloads.gtnewhorizons.com/versions.json"
STABLE_ONLY = re.compile(r"^\d+\.\d+\.\d+$")

def get_versions():
    res = requests.get(VERSIONS_URL)
    return res.json()["versions"]

def filter_json(data):
    '''
    Clean up release candidate versions, april fools versions, and beta versions
    '''
    data_cleaned = {}
    for version, value in data.items():
        if STABLE_ONLY.match(version):
            data_cleaned[version] = value

    filtered = {
        version: {
            "javaVersion": value["maxJavaVersion"],
            "releaseDate": value["releaseDate"],
            "java8Url": value["server"]["java8Url"],
            "java17_2XUrl": value["server"]["java17_2XUrl"],
        } 
        for version, value in data_cleaned.items()}
    return filtered

versions = get_versions()
filtered = filter_json(versions)
json_thing = json.dumps(filtered, indent=4)

with open("versions.json", "w") as f:
    f.write(json_thing)

# if __name__ == "__main__":
#     with open(Path(__file__).parent / "versions.json", "w") as file:
#         json.dump(generate(), file, indent=2)
#         file.write("\n")
