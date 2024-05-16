# This file builds ELPA
include(UtilityMacros)
include(DependencyMacros)

if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "OpenBLAS" OR ${LINALG_VENDOR} STREQUAL "IBMESSL")
  include(cmsb_linalg)
  foreach(depend BLAS LAPACK ScaLAPACK)
    find_or_build_dependency(${depend})
    package_dependency(${depend} DEPENDENCY_PATHS)
  endforeach()
endif()

ExternalProject_Add(ELPA_External
        SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/ELPA
        CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
                -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_ROOT}
                -DSTAGE_DIR=${STAGE_DIR}
        #BUILD_ALWAYS 1
        INSTALL_COMMAND ""
        CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                         ${CORE_CMAKE_STRINGS}
                         ${DEPENDENCY_PATHS}
)

# Establish the dependencies
if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "IBMESSL" OR ${LINALG_VENDOR} STREQUAL "OpenBLAS")
    if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "OpenBLAS")
        add_dependencies(ELPA_External BLAS_External LAPACK_External)
    elseif(${LINALG_VENDOR} STREQUAL "IBMESSL")
        add_dependencies(ELPA_External LAPACK_External)
    endif()
    if(USE_SCALAPACK)
        add_dependencies(ELPA_External ScaLAPACK_External)
    endif()
endif()