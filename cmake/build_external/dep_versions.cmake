# Pin dependency versions

set(CMSB_HDF5_VERSION hdf5_1.14.4.3)
set(CMSB_DOCTEST_VERSION 2.4.9)
set(CMSB_ELPA_VERSION 2024.03.001)

set(TAMM_GIT_TAG 2024-06-17)
if(ENABLE_DEV_MODE OR USE_TAMM_DEV)
    set(TAMM_GIT_TAG develop)
endif()

# numactl
set(NUMACTL_GIT_TAG v2.0.18)

# Eigen3
set(EIGEN_GIT_TAG e887196d9d67e48c69168257d599371abf1c3b31) #Mar 17, 2023
if(ENABLE_DEV_MODE)
  set(EIGEN_GIT_TAG master)
endif()

# spdlog
set(SPDLOG_GIT_TAG v1.14.1)
if(ENABLE_DEV_MODE)
  set(SPDLOG_GIT_TAG v1.x)
endif()

# BLIS
set(BLIS_GIT_TAG 1.0)

if(USE_SCALAPACK)
  #The next commit breaks scalapack builds
  set(BLIS_GIT_TAG 6f412204004666abac266409a203cb635efbabf3)
endif()

# OpenBLAS
set(OpenBLAS_GIT_TAG 0.3.27)

# LAPACK
set(LAPACK_GIT_TAG 8b468db25c0c5a25d8e0020c7e2134e14cfd33d0)
if(ENABLE_DEV_MODE)
  set(LAPACK_GIT_TAG master)
endif()

# ScaLAPACK
set(SL_GIT_TAG 0234af94c6578c53ac4c19f2925eb6e5c4ad6f0f)
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
set(GA_GIT_TAG 6636f3ec85b9bf752f5fd9813faa11b0ddd75b7a)
if(ENABLE_DEV_MODE)
    set(GA_GIT_TAG develop)
endif()

# HPTT
set(HPTT_GIT_TAG eff1bdd79734ddc4993dd4df1d0cdbd40758b9cb)
if(ENABLE_DEV_MODE)
    set(HPTT_GIT_TAG master)
endif()

# Librett
set(LIBRETT_GIT_TAG 818f4f5e5a58e837cc6e71300703b65266a1039b)
if(ENABLE_DEV_MODE)
  set(LIBRETT_GIT_TAG master)
endif()

# Libint
set(CMSB_LIBINT_VERSION 2.9.0)

# LibEcpInt
set(ECPINT_GIT_TAG ee6d75a969bb92535a9ecf2ba4b564a75b7ef84b)
if(ENABLE_DEV_MODE)
  set(ECPINT_GIT_TAG master)
endif()

# GauXC
set(GXC_GIT_TAG 2c94d73e779a817dfc48a9d8629df7fdfba636d7)
if(ENABLE_DEV_MODE)
    set(GXC_GIT_TAG master)
endif()

# Unused
set(PYBIND_GIT_TAG master)
if(ENABLE_DEV_MODE)
  set(PYBIND_GIT_TAG master)
endif()

set(MACIS_GIT_TAG master)
if(ENABLE_DEV_MODE)
  set(MACIS_GIT_TAG master)
endif()
