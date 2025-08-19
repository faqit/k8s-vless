#!/bin/bash
if [[ $EUID -ne 0 ]]; then
  echo "Use root or SUDO" >&2
  exit 1
fi
PathToFile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash $PathToFile/uuidgen.sh
bash $PathToFile/keygen.sh
bash $PathToFile/prepareconfig.sh
