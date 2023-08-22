
set(LIBRETT_GIT_TAG master)
if(ENABLE_DEV_MODE)
  set(LIBRETT_GIT_TAG master)
endif()

is_valid_and_true(LIBRETT_TAG __lt_set)
if(__lt_set)
  set(LIBRETT_GIT_TAG ${LIBRETT_TAG})
endif()

if(ENABLE_OFFLINE_BUILD)
ExternalProject_Add(Librett_External
    URL ${DEPS_LOCAL_PATH}/Librett
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DENABLE_SYCL=${USE_DPCPP}
    -DENABLE_CUDA=${USE_CUDA} -DENABLE_HIP=${USE_HIP} -DCMAKE_CUDA_ARCHITECTURES=${GPU_ARCH} 
    -DCMAKE_HIP_ARCHITECTURES=${GPU_ARCH} -DROCM_PATH=${ROCM_ROOT} -DENABLE_TESTS=OFF
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)
else()
ExternalProject_Add(Librett_External
    GIT_REPOSITORY https://github.com/victor-anisimov/Librett.git
    GIT_TAG ${LIBRETT_GIT_TAG}
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DENABLE_SYCL=${USE_DPCPP}
    -DENABLE_CUDA=${USE_CUDA} -DENABLE_HIP=${USE_HIP} -DCMAKE_CUDA_ARCHITECTURES=${GPU_ARCH} 
    -DCMAKE_HIP_ARCHITECTURES=${GPU_ARCH} -DROCM_PATH=${ROCM_ROOT} -DENABLE_TESTS=OFF
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)
endif()
#    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DENABLE_SYCL=${USE_DPCPP}
#    -DENABLE_CUDA=${USE_CUDA} -DENABLE_HIP=${USE_HIP} -DCMAKE_CUDA_ARCHITECTURES=${GPU_ARCH} 
#    -DROCM_ROOT=${ROCM_ROOT} -DENABLE_SYCL_CUDA=${ENABLE_SYCL_CUDA} -DENABLE_SYCL_HIP=${ENABLE_SYCL_HIP} 
#    -DCMAKE_HIP_ARCHITECTURES=${GPU_ARCH} -DCUDA_ROOT=${CUDA_ROOT} -DENABLE_TESTS=OFF

