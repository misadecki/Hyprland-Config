#!/usr/bin/env bash

grim -g "$(slurp -w 1 ; sleep 0.2)" - | swappy -f -
