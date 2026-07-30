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
if [[ "$core" == "CV32E40X" ]]; then
  echo "Exporting control core (CV32E40X) ISA extensions: I, M, A, F, C"
  export CTRL_XTEN=imafc
else
  echo "Exporting control core (CV32E40P) ISA extensions: I, M, C, PULP (Zfinx)"
  export CTRL_XTEN=imc_xcvalu_xcvbi_xcvbitmanip_xcvhwlp_xcvmac_xcvmem_xcvsimd_xcvelw_zfinx_zhinxmin
fi
echo "Exporting PULP cluster core (CV32E40P) ISA extensions: I, M, C, PULP (Zfinx)"
export CLUSTER_XTEN=imc_xcvalu_xcvbi_xcvbitmanip_xcvhwlp_xcvmac_xcvmem_xcvsimd_xcvelw_zfinx_zhinxmin
echo "Sourcing python virtual environment"
source ./magia_venv/bin/activate
echo "Finished setting up the environment"