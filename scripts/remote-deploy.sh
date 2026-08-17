#!/usr/bin/env bash

nixos-rebuild switch --flake .#woof --max-jobs 16 --show-trace --target-host deploy@woof-deploy --use-remote-sudo
