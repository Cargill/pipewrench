#!/usr/bin/env bash
for table in titanic baseball vocab;do
   pushd ${table}
   # Run the test-targets script to ensure all targets are available
   make clean
   make source-create
   make first-run
   make test-recordcount
   make source-table-clean
   make clean
   popd
done