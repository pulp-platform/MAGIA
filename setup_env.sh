core="$1"
echo "Selected core: $core"

export MAGIA_DIR=$(pwd)
echo "Exporting MAGIA path to $MAGIA_DIR"
export PATH=$MAGIA_DIR:$PATH
export BENDER_DIR=$(pwd)/hw/bender
echo "Exporting bender path to $BENDER_DIR"
export PATH=$BENDER_DIR:$PATH
unset BENDER_DIR
echo "Exporting SDK and GCC Toolchain paths"
export XLEN=32
if [[ "$core" == "CV32E40P" ]] || [[ "$core" == "RI5CY" ]]; then
  echo "Exporting ISA extentions: I, M, C, PULP"
  export XTEN=imfc
else
  echo "Exporting ISA extentions: I, M, A, F, C"
  export XTEN=imafc
fi
echo "Sourcing python virtual environment"
source ./magia_venv/bin/activate
echo "Finished setting up the environment"