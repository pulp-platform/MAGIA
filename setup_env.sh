
export MAGIA_DIR=$(pwd)
echo "Exporting MAGIA path to $MAGIA_DIR"
export PATH=$MAGIA_DIR:$PATH
export BENDER_DIR=$(pwd)/hw/bender
echo "Exporting bender path to $BENDER_DIR"
export PATH=$BENDER_DIR:$PATH
unset BENDER_DIR
echo "Exporting SDK and GCC Toolchain paths"
echo "Sourcing python virtual environment"
source ./magia_venv/bin/activate
echo "Finished setting up the environment"