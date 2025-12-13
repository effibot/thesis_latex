#!/bin/bash
# Get the absolute path of the workspace root (assuming script is in scripts/)
WORKSPACE_ROOT=$(dirname $(dirname $(realpath $0)))

# Run texcount inside the docker container
# We mount the current directory (which should be the workspace or a subdir)
# and set the working directory to the same path inside the container.
docker run --rm -v "$WORKSPACE_ROOT:$WORKSPACE_ROOT" -w "$PWD" latex-thesis-env texcount "$@"
