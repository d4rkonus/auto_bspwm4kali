#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    exit 1
    echo "debes ser root, pinche puto"
fi

