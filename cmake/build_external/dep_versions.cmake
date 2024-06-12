# Pin dependency versions

set(CMSB_HDF5_VERSION hdf5-1_14_2)
set(CMSB_DOCTEST_VERSION 2.4.9)
set(CMSB_ELPA_VERSION 2024.03.001)

set(TAMM_GIT_TAG 2024-06-11)
if(ENABLE_DEV_MODE OR USE_TAMM_DEV)
    set(TAMM_GIT_TAG develop)
endif()

# numactl
set(NUMACTL_GIT_TAG 8c454ecb0e274d254a9393346297936e67ef9e05)

# Eigen3
set(EIGEN_GIT_TAG e887196d9d67e48c69168257d599371abf1c3b31) #Mar 17, 2023
if(ENABLE_DEV_MODE)
  set(EIGEN_GIT_TAG master)
endif()

# spdlog
set(SPDLOG_GIT_TAG cedfeeb95f3af11df7d3b1e7e0d3b86b334dc23b)
if(ENABLE_DEV_MODE)
  set(SPDLOG_GIT_TAG v1.x)
endif()

# BLIS
set(BLIS_GIT_TAG 7a87e57b69d697a9b06231a5c0423c00fa375dc1)

if(USE_SCALAPACK)
  #The next commit breaks scalapack builds
  set(BLIS_GIT_TAG 6f412204004666abac266409a203cb635efbabf3)
endif()

# OpenBLAS
set(OpenBLAS_GIT_TAG 0.3.27)

# LAPACK
set(LAPACK_GIT_TAG eb8f5fa6462a483431c258f4d6831aa3d4192771)
if(ENABLE_DEV_MODE)
  set(LAPACK_GIT_TAG master)
endif()

# ScaLAPACK
set(SL_GIT_TAG 2072b8602f0a5a84d77a712121f7715c58a2e80d)
if(ENABLE_DEV_MODE)
  set(SL_GIT_TAG master)
endif()

# NJSON
set(NJSON_GIT_TAG 3.11.3) #Do not use commit hash for NJSON
set(CMSB_NJSON_VERSION ${NJSON_GIT_TAG})

# GSL
set(MSGSL_GIT_TAG 3ba80d5dd465828909e1ee756b8c437d5e820ccc)
if(ENABLE_DEV_MODE)
  set(MSGSL_GIT_TAG main)
endif()

# Global Arrays
set(GA_GIT_TAG 32fdc5d9cf6351daed95d64c9757f116db6ee62f)
if(ENABLE_DEV_MODE)
    set(GA_GIT_TAG develop)
endif()

# HPTT
set(HPTT_GIT_TAG eff1bdd79734ddc4993dd4df1d0cdbd40758b9cb)
if(ENABLE_DEV_MODE)
    set(HPTT_GIT_TAG master)
endif()

# Librett
set(LIBRETT_GIT_TAG fd42f11602542164d46922b11e8258ba82be8f73)
if(ENABLE_DEV_MODE)
  set(LIBRETT_GIT_TAG master)
endif()

# Libint
set(CMSB_LIBINT_VERSION 2.9.0)

# LibEcpInt
set(ECPINT_GIT_TAG 8e788d4ea9b74e464dd834441369e3e8488256d9)
if(ENABLE_DEV_MODE)
  set(ECPINT_GIT_TAG master)
endif()

# GauXC
set(GXC_GIT_TAG be9ac8d014b139ccaccc63bb259a062a9b2b2b6b)
if(ENABLE_DEV_MODE)
    set(GXC_GIT_TAG master)
endif()

# Unused
set(PYBIND_GIT_TAG 35ff42b56e9d34d9a944266eb25f2c899dbdfed7)
if(ENABLE_DEV_MODE)
  set(PYBIND_GIT_TAG master)
endif()

set(MACIS_GIT_TAG master)
if(ENABLE_DEV_MODE)
  set(MACIS_GIT_TAG master)
endif()
