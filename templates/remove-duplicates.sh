#!/bin/bash
#    Copyright 2017 Cargill Incorporated
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.


# Remove duplicate scripts/templates and put into ./shared dir
# Depends on fdupes: https://github.com/adrianlopezroche/fdupes
set -euo pipefail
function move {
  echo "moving $1" >&2
  IMPORTS_FILE=`dirname $1`/imports
  if [[ ! -z $IMPORTS_FILE ]]; then
      touch $IMPORTS_FILE
  fi

  echo "../shared/`basename $1`" >> $IMPORTS_FILE
  mv $1 shared
}

DUPES=`fdupes -1 -r . |  cut -d' ' -f 1 | xargs basename | grep -v imports` | grep -v type-mapping
echo "duplicates: $DUPES" >&2
while read -r line
do
    find . -name $line -not -path "./shared" -exec $(move) {} \;
done <<< "$DUPES"
