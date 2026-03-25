#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.requests python3Packages.dataclasses-json

import json
import requests
import re

VERSIONS_URL = "https://gtnh-versions.041095.xyz/versions.json"
STABLE_ONLY = re.compile(r"^\d+\.\d+\.\d+$")

def get_versions():
    res = requests.get(VERSIONS_URL)
    return res.json()

def filter_json(data):
    '''
    Clean up release candidate versions, april fools versions, and beta versions
    '''
    filtered = {}
    for version, value in data.items():
        if STABLE_ONLY.match(version):
            filtered[version] = value

    return filtered

versions = get_versions()
filtered = filter_json(versions)

with open("versions.json", "w") as f:
    json.dump(filtered, f, indent=4)

# if __name__ == "__main__":
#     with open(Path(__file__).parent / "versions.json", "w") as file:
#         json.dump(generate(), file, indent=2)
#         file.write("\n")
