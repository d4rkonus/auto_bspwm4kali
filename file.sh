#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "debes ser root, pinche puto"
    exit 1
fi

