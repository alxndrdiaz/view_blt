#!/bin/bash

# Docker image
img='genomehubs/blobtoolkit:4.0.7'

# required input paths and parameters (use default ARGS):
BDIR="BDQP01"
ARGS="--host http://localhost --timeout 30 --ports 8000-8099"

echo "btk pipeline generate-static-images":
docker run \
  --rm \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  -t ${img} \
  ./bin/view.sh $BDIR "$BDIR" "TRUE" "$ARGS"
echo

