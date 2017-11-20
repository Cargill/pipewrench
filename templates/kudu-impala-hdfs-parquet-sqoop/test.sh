#!/usr/bin/env bash
{#  Copyright 2017 Cargill Incorporated

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. -#}
#!/bin/bash
# Run a simple test to compare table counts
set -euo pipefail
ACTUAL=$(<test-kudu-rowcount)
EXPECTED=1000

if [[ "$ACTUAL" -ge $EXPECTED ]]; then
    echo "passed"
    echo "actual: $ACTUAL, expected: $EXPECTED"
else
    echo "failed"
    echo "actual: $ACTUAL, expected: $EXPECTED"
    exit 1
fi

