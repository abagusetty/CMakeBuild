set(CMSB_MACROS ${CMAKE_CURRENT_LIST_DIR})

function(build_cmsb_module SUPER_PROJECT_ROOT)

    #Set the environment up and pull-in macros we'll need
    include(${CMSB_MACROS}/SetPaths.cmake)
    set_paths() #Puts macro paths in module path
    include(OptionMacros)
    include(DependencyMacros)
    include(ExternalProject)
    include(UtilityMacros)
    include(CheckCCompilerFlag)
    include(CheckCXXCompilerFlag)
    include(CheckFortranCompilerFlag)

    option_w_default(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    option_w_default(BLAS_INT4 ON)
    option_w_default(LINALG_VENDOR BLIS)
    option_w_default(ENABLE_COVERAGE OFF)
    option_w_default(CMAKE_CXX_EXTENSIONS OFF)
    option_w_default(CMAKE_BUILD_TYPE Release)
    option_w_default(USE_OPENMP OFF)
    option_w_default(USE_DPCPP OFF)
    option_w_default(ENABLE_DPCPP ${USE_DPCPP})
    option_w_default(USE_CUDA OFF)
    option_w_default(USE_HIP OFF)
    option_w_default(USE_TAMM_DEV OFF)
    option_w_default(USE_GA_PROFILER OFF)
    option_w_default(GA_ENABLE_SYSV OFF)
    option_w_default(USE_SCALAPACK OFF)
    option_w_default(CUDA_MAXREGCOUNT 128)
    option_w_default(BUILD_SHARED_LIBS OFF)
    option_w_default(ENABLE_DEV_MODE OFF)

    option_w_default(ENABLE_OFFLINE_BUILD OFF)
    option_w_default(USE_UPCXX_DISTARRAY OFF)
    option_w_default(USE_UPCXX ${USE_UPCXX_DISTARRAY})

    #Detect invalid combinations
    if(USE_CUDA AND USE_HIP)
      message(FATAL_ERROR "USE_CUDA and USE_HIP cannot be enabled simultaneously")
    endif()
    if(USE_CUDA OR USE_HIP)
      if(USE_DPCPP)
        message(FATAL_ERROR "USE_DPCPP cannot be enabled with USE_CUDA or USE_HIP enabled")
      endif()
    endif()

    if(USE_DPCPP)
        if(USE_OPENMP)
          message(FATAL_ERROR "DPCPP build requires USE_OPENMP=OFF")
        endif()
        message(STATUS "DPCPP Option Enabled: Setting BUILD_SHARED_LIBS to : ON")
        set(BUILD_SHARED_LIBS ON)
        # option_w_default(SYCL_TBE xehp)
    endif()

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
        if(NOT "${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
            if(GCCROOT)
              set(__CMSB_GCC_INSTALL_PREFIX ${GCCROOT})
              set(CMSB_GCC_TOOLCHAIN_FLAG "--gcc-toolchain=${GCCROOT}")
            else()
              get_filename_component(__CMSB_GCC_INSTALL_PREFIX "${CMAKE_Fortran_COMPILER}/../.." ABSOLUTE)
              if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
                set(CMSB_GCC_TOOLCHAIN_FLAG "--gcc-toolchain=${__CMSB_GCC_INSTALL_PREFIX}")
              else()
                message(FATAL_ERROR "GCCROOT cmake option not set when using clang compilers. \
                        Please set a valid path to the GCC installation.")
              endif()
            endif()
            #Check GCC installation
            if(NOT 
               (EXISTS ${__CMSB_GCC_INSTALL_PREFIX}/bin AND
                EXISTS ${__CMSB_GCC_INSTALL_PREFIX}/include AND
                EXISTS ${__CMSB_GCC_INSTALL_PREFIX}/lib)
              )
              message(FATAL_ERROR "GCC installation path found ${__CMSB_GCC_INSTALL_PREFIX} seems to be incorrect. \
              Please set the GCCROOT cmake option to the correct GCC installation prefix.")
            endif()
            message(STATUS "CMSB_GCC_TOOLCHAIN_FLAG: ${CMSB_GCC_TOOLCHAIN_FLAG}")
        endif()
    endif()

    if(DEFINED MARCH_FLAGS)
        set(CMSB_MARCH_FLAGS ${MARCH_FLAGS})
    else()
        if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
            set(CMSB_MARCH_FLAGS "-xHost")
        elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc64le")
            set(CMSB_MARCH_FLAGS "-mtune=native")
            if(USE_CUDA)
                #nvcc does not recgonize -mtune=power9
                set(CMSB_MARCH_FLAGS "-mtune=powerpc64le")
            endif()
        #elseif(CMAKE_CXX_COMPILER_ID STREQUAL "ARMClang")
        elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64") 
            set(CMSB_MARCH_FLAGS "-mcpu=native")
        else()
            set(CMSB_MARCH_FLAGS "-march=native")
        endif()
    endif()

    check_c_compiler_flag("${CMSB_MARCH_FLAGS}" __C_COMPILER_SUPPORTS_MARCH)
    if(__C_COMPILER_SUPPORTS_MARCH)
        set(CMSB_EXTRA_FLAGS "${CMSB_MARCH_FLAGS}")
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wall ${CMSB_EXTRA_FLAGS}")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Wall ${CMSB_EXTRA_FLAGS}")
        set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -Wall ${CMSB_EXTRA_FLAGS}")
    endif()

    check_cxx_compiler_flag("${CMSB_MARCH_FLAGS}" __CXX_COMPILER_SUPPORTS_MARCH)
    if(__CXX_COMPILER_SUPPORTS_MARCH)
        set(CMSB_EXTRA_FLAGS "${CMSB_MARCH_FLAGS}")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall ${CMSB_EXTRA_FLAGS}")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall ${CMSB_EXTRA_FLAGS}")
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -Wall ${CMSB_EXTRA_FLAGS}")
    endif()

    check_fortran_compiler_flag("${CMSB_MARCH_FLAGS}" __Fort_COMPILER_SUPPORTS_MARCH)
    if(__Fort_COMPILER_SUPPORTS_MARCH)
        set(CMSB_EXTRA_FLAGS "${CMSB_MARCH_FLAGS}")
        set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -Wall ${CMSB_EXTRA_FLAGS}")
        set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -Wall ${CMSB_EXTRA_FLAGS}")
        set(CMAKE_Fortran_FLAGS_RELWITHDEBINFO "${CMAKE_Fortran_FLAGS_RELWITHDEBINFO} -Wall ${CMSB_EXTRA_FLAGS}")
    endif()


    string(TOUPPER ${CMAKE_BUILD_TYPE} CMSB_CMAKE_BUILD_TYPE)
    set(CMSB_C_FLAGS CMAKE_C_FLAGS_${CMSB_CMAKE_BUILD_TYPE})
    set(CMSB_CXX_FLAGS CMAKE_CXX_FLAGS_${CMSB_CMAKE_BUILD_TYPE})
    set(CMSB_Fortran_FLAGS CMAKE_Fortran_FLAGS_${CMSB_CMAKE_BUILD_TYPE})

    if ("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "arm64" AND "${LINALG_VENDOR}" STREQUAL "IntelMKL")
        message( FATAL_ERROR "IntelMKL is not supported for ARM architectures" )
    endif()

    if(NOT BLAS_INT4 AND USE_SCALAPACK) # AND NOT "${LINALG_VENDOR}" STREQUAL "IntelMKL")
        message( FATAL_ERROR "ScaLAPACK build with ILP64 interface is currently not supported. Please set -DBLAS_INT4=ON" )
    endif()

    print_banner("Configuration Options")
    
    option_w_default(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
    option_w_default(BUILD_TESTS ON)    #Should we build the tests?
    option_w_default(BUILD_METHODS ON)
    option_w_default(CMSB_DEBUG_CMAKE TRUE) #Enable lots of extra CMake printing?
    option_w_default(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    option_w_default(CMAKE_VERBOSE_MAKEFILE ${CMSB_DEBUG_CMAKE})
    option_w_default(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY TRUE)

    print_banner("CMSB Module Paths")

    option_w_default(CMSB_PROJECTS ${PROJECT_NAME}) # List of modules to build
    foreach(__project ${CMSB_PROJECTS})
        #Directory where the sub-project's source is located
        option_w_default(${__project}_SRC_DIR ${SUPER_PROJECT_ROOT}/${__project})
        #Includes should be relative to CMSB_SRC_DIR without last directory
        get_filename_component(${__project}_INCLUDE_DIR "${${__project}_SRC_DIR}"
                DIRECTORY)
        #Directory where your tests are
        option_w_default(${__project}_TEST_DIR
                ${SUPER_PROJECT_ROOT}/${__project}_Test)
        #Name of variable containing your project's dependencies
        option_w_default(${__project}_DEPENDENCIES "")
    endforeach()

    set(SUPER_PROJECT_BINARY_DIR ${CMAKE_BINARY_DIR})
    set(CMSB_CORE_OPTIONS CMAKE_CXX_COMPILER CMAKE_C_COMPILER SUPER_PROJECT_BINARY_DIR
        CMAKE_Fortran_COMPILER CMAKE_BUILD_TYPE BUILD_SHARED_LIBS ${CMSB_C_FLAGS} ${CMSB_CXX_FLAGS} ${CMSB_Fortran_FLAGS}
        CMAKE_INSTALL_PREFIX CMAKE_CXX_STANDARD CMAKE_VERSION PROJECT_VERSION
        CMAKE_POSITION_INDEPENDENT_CODE CMAKE_VERBOSE_MAKEFILE CMAKE_CXX_EXTENSIONS
        CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY CMAKE_EXPORT_COMPILE_COMMANDS 
        MPIEXEC_EXECUTABLE JOB_LAUNCH_CMD JOB_LAUNCH_ARGS PYTHON_EXECUTABLE CMAKE_C_FLAGS_INIT CMAKE_CXX_FLAGS_INIT)

    if(USE_CUDA)
        bundle_cmake_args(CMSB_CORE_OPTIONS CMAKE_CUDA_ARCHITECTURES)
    elseif(USE_HIP)
        bundle_cmake_args(CMSB_CORE_OPTIONS CMAKE_HIP_ARCHITECTURES)
    endif()
    
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

    #Make a list of all CMake variables that should be passed to all dependencies
    bundle_cmake_args(CORE_CMAKE_OPTIONS ${CMSB_CORE_OPTIONS})

    bundle_cmake_list(CORE_CMAKE_LISTS CMAKE_PREFIX_PATH CMAKE_MODULE_PATH 
                         CMSB_LAM_PATH CMAKE_INSTALL_RPATH_USE_LINK_PATH)

    bundle_cmake_strings(CORE_CMAKE_STRINGS ${CMSB_C_FLAGS} ${CMSB_CXX_FLAGS} ${CMSB_Fortran_FLAGS})

    bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS ${CMSB_CORE_OPTIONS})

    bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS BLAS_INT4 LINALG_VENDOR LINALG_PREFIX ENABLE_COVERAGE USE_SCALAPACK)
    bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS BLIS_CONFIG GCCROOT HDF5_ROOT LibInt2_ROOT)

    bundle_cmake_strings(CORE_CMAKE_STRINGS ENABLE_DEV_MODE GPU_ARCH MARCH_FLAGS USE_TAMM_DEV CMSB_TAG)
    bundle_cmake_strings(CORE_CMAKE_STRINGS USE_DPCPP SYCL_TBE ENABLE_DPCPP)
    bundle_cmake_strings(CORE_CMAKE_STRINGS USE_HIP ROCM_ROOT)
    bundle_cmake_strings(CORE_CMAKE_STRINGS USE_UPCXX USE_UPCXX_DISTARRAY)
    bundle_cmake_strings(CORE_CMAKE_STRINGS USE_CUDA CUDA_MAXREGCOUNT)

    bundle_cmake_strings(CORE_CMAKE_STRINGS GA_ENABLE_SYSV)
    if(GA_TAG)
        bundle_cmake_strings(CORE_CMAKE_STRINGS GA_TAG)
    endif()
    if(GA_RUNTIME)
        bundle_cmake_strings(CORE_CMAKE_STRINGS GA_RUNTIME)
    endif()
    if(USE_GA_PROFILER)
        bundle_cmake_strings(CORE_CMAKE_STRINGS USE_GA_PROFILER)
    endif()
    if(LIBRETT_TAG)
        bundle_cmake_strings(CORE_CMAKE_STRINGS LIBRETT_TAG)
    endif()
    if(MODULES)
        list(TRANSFORM MODULES TOUPPER)
        bundle_cmake_strings(CORE_CMAKE_STRINGS MODULES)
        bundle_cmake_strings(CORE_CMAKE_STRINGS LIBINT_ERI)
        if ("DFT" IN_LIST MODULES)
            if(NOT BLAS_INT4)
                message( FATAL_ERROR "GauXC build with ILP64 interface is currently not supported. Please set -DBLAS_INT4=ON" )
            endif()
            list(APPEND MODULE_CXX_FLAGS -DUSE_GAUXC)
        endif()
        if ("FCI" IN_LIST MODULES)
            list(APPEND MODULE_CXX_FLAGS -DUSE_MACIS)
        endif()
    endif()

    if(USE_CRAYSHASTA)
        bundle_cmake_strings(CORE_CMAKE_STRINGS USE_CRAYSHASTA)
    endif()

    if(CMAKE_CUDA_COMPILER_ID STREQUAL "Clang")
        bundle_cmake_strings(CORE_CMAKE_STRINGS CMAKE_CUDA_COMPILER)
    endif()

    if(ENABLE_OFFLINE_BUILD)
        bundle_cmake_strings(CORE_CMAKE_STRINGS ENABLE_OFFLINE_BUILD DEPS_LOCAL_PATH)
    endif()

    if(USE_OPENMP)
        bundle_cmake_strings(CORE_CMAKE_STRINGS USE_OPENMP)
        if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "IntelLLVM")
            if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin" OR USE_DPCPP)
                bundle_cmake_strings(CORE_CMAKE_STRINGS OpenMP_C_FLAGS OpenMP_CXX_FLAGS)
                bundle_cmake_strings(CORE_CMAKE_STRINGS OpenMP_C_LIB_NAMES OpenMP_CXX_LIB_NAMES OpenMP_omp_LIBRARY OpenMP_libiomp5_LIBRARY)
            endif()
        endif()
    endif()

    print_banner("Locating Dependencies and Creating Targets")
    ################################################################################
    #
    # Add the subprojects, their dependencies, and their tests
    #
    ################################################################################

    set(DEPENDENCY_ROOT_DIRS)

    foreach(__project ${CMSB_PROJECTS})
        if(TAMM_CXX_FLAGS)
            string (REPLACE " " ";" TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS}")
        endif()
        list(APPEND TAMM_CXX_FLAGS ${CMSB_GCC_TOOLCHAIN_FLAG} -DOMPI_SKIP_MPICXX)

        if (USE_SCALAPACK) 
          list(APPEND TAMM_CXX_FLAGS -DUSE_SCALAPACK)
        endif()

        if(TAMM_EXTRA_LIBS)
          string (REPLACE " " ";" TAMM_EXTRA_LIBS "${TAMM_EXTRA_LIBS}")
        endif()

        if(ENABLE_COVERAGE)
            list(APPEND TAMM_CXX_FLAGS --coverage)
            list(APPEND TAMM_EXTRA_LIBS --coverage)
        endif()

        list(APPEND TAMM_CXX_FLAGS ${MODULE_CXX_FLAGS})

        if(USE_CUDA)
            list(APPEND TAMM_CXX_FLAGS -DUSE_CUDA)
            if(GPU_ARCH GREATER_EQUAL 80)
                list(APPEND TAMM_CXX_FLAGS -DUSE_NV_TC)
            endif()
        elseif(USE_HIP)
            list(APPEND TAMM_CXX_FLAGS -DUSE_HIP)
        endif()

        if(USE_DPCPP)
            list(APPEND TAMM_CXX_FLAGS -DUSE_DPCPP) #-fsycl
        endif()      

        if(USE_UPCXX)
            list(APPEND TAMM_CXX_FLAGS -DUSE_UPCXX)
            if(USE_UPCXX_DISTARRAY)
                list(APPEND TAMM_CXX_FLAGS -DUSE_UPCXX_DISTARRAY)
            endif()
        endif()

        string (REPLACE ";" " " TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS}")
        set(${CMSB_CXX_FLAGS} "${${CMSB_CXX_FLAGS}} ${TAMM_CXX_FLAGS}")
        if(USE_DPCPP)
            if(SYCL_TBE)
                set(${CMSB_CXX_FLAGS} "${${CMSB_CXX_FLAGS}} -Xs '-device ${SYCL_TBE}'")
            endif()
        endif()

        bundle_cmake_strings(CORE_CMAKE_STRINGS ${CMSB_C_FLAGS} ${CMSB_CXX_FLAGS} ${CMSB_Fortran_FLAGS})
        #Cache only for writing to package configuration files.
        bundle_cmake_strings(CORE_CMAKE_STRINGS TAMM_CXX_FLAGS)

        if(TAMM_EXTRA_LIBS)
            bundle_cmake_strings(CORE_CMAKE_STRINGS TAMM_EXTRA_LIBS)
            message(STATUS "TAMM_EXTRA_LIBS: ${TAMM_EXTRA_LIBS}")
        endif()


        foreach(depend ${${__project}_DEPENDENCIES})
            find_or_build_dependency(${depend})
            are_we_building(${depend} were_building)
            if(were_building)
                list(APPEND DEPENDS_WERE_BUILDING ${depend})
            else()
                list(APPEND DEPENDS_WE_FOUND ${depend})
                package_dependency(${depend} DEPENDENCY_PATHS)
            endif()

            is_valid(${depend}_ROOT __deproot_set)
            if(__deproot_set)
                bundle_cmake_args(DEPENDENCY_ROOT_DIRS ${depend}_ROOT)
            endif()
        endforeach()

        ExternalProject_Add(${__project}_External
                SOURCE_DIR ${${__project}_SRC_DIR}
                CMAKE_ARGS -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                           -DCMSB_INCLUDE_DIR=${${__project}_INCLUDE_DIR}
                           -DSTAGE_DIR=${STAGE_DIR}
                           ${CORE_CMAKE_OPTIONS}
                           ${DEPENDENCY_ROOT_DIRS}
                BUILD_ALWAYS 1
                INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
                CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                 ${CORE_CMAKE_STRINGS}
                                #  ${DEPENDENCY_PATHS}
                -DCMSB_DEPENDENCIES:STRING=${${__project}_DEPENDENCIES}
                )

        foreach(depend ${${__project}_DEPENDENCIES})
            add_dependencies(${__project}_External ${depend}_External)
        endforeach()

        # Fix for serial make problem where CMakeBuild_External is not built
        # if(${__project} STREQUAL "TAMM")
        #     add_dependencies(${__project}_External CMakeBuild_External)
        # endif()

        if(${BUILD_TESTS})
            list(APPEND TEST_DEPENDS "CMakeBuild" "${__project}" "${${__project}_DEPENDENCIES}")
            ExternalProject_Add(${__project}_Tests_External
                    SOURCE_DIR ${${__project}_TEST_DIR}
                    CMAKE_ARGS -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_ROOT}
                               -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                               -DSTAGE_DIR=${STAGE_DIR}
                               -DSTAGE_INSTALL_DIR=${STAGE_INSTALL_DIR}
                               ${CORE_CMAKE_OPTIONS}

                    BUILD_ALWAYS 1
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${TEST_STAGE_DIR}
                    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                     ${CORE_CMAKE_STRINGS}
                                    #  ${DEPENDENCY_PATHS}
                                     -DCMSB_DEPENDENCIES:LIST=${TEST_DEPENDS}
                    )
            add_dependencies(${__project}_Tests_External ${__project}_External)

            # This file will allow us to run ctest in the top-level build dir
            # Basically it just defers to the actual top-level CTestTestfile.cmake in the
            # build directory for this project
            file(WRITE ${CMAKE_BINARY_DIR}/CTestTestfile.cmake
                    "subdirs(test_stage${CMAKE_INSTALL_PREFIX}/tests)")
        endif()
        if(${BUILD_METHODS})
            list(APPEND METHOD_DEPENDS "CMakeBuild" "${__project}" "${${__project}_DEPENDENCIES}")
            ExternalProject_Add(${__project}_Methods_External
                    SOURCE_DIR ${${__project}_METHODS_DIR}
                    CMAKE_ARGS -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_ROOT}
                               -DSUPER_PROJECT_BINARY_DIR=${SUPER_PROJECT_BINARY_DIR}
                               -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                               -DSTAGE_DIR=${STAGE_DIR}
                               -DSTAGE_INSTALL_DIR=${STAGE_INSTALL_DIR}
                               ${CORE_CMAKE_OPTIONS}

                    BUILD_ALWAYS 1
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${METHODS_STAGE_DIR}
                    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                     ${CORE_CMAKE_STRINGS}
                                     ${DEPENDENCY_PATHS}
                                     -DCMSB_DEPENDENCIES:LIST=${METHOD_DEPENDS}
                    )
            add_dependencies(${__project}_Methods_External ${__project}_External)

            # This file will allow us to run ctest in the top-level build dir
            # Basically it just defers to the actual top-level CTestTestfile.cmake in the
            # build directory for this project
            file(APPEND ${CMAKE_BINARY_DIR}/CTestTestfile.cmake
                    "\nsubdirs(methods_stage${CMAKE_INSTALL_PREFIX}/methods)")

            install(DIRECTORY ${METHODS_STAGE_DIR}${CMAKE_INSTALL_PREFIX}/methods/
                    DESTINATION ${CMAKE_INSTALL_PREFIX}/bin USE_SOURCE_PERMISSIONS
                    PATTERN "*.cmake" EXCLUDE)
        endif()        
    endforeach()

    # Install the staging directory
    install(DIRECTORY ${STAGE_INSTALL_DIR}/
            DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)

    if(DEFINED CMSB_BASISSET_DIR)
        if(TARGET Libint2::cxx)
            get_target_property(LI_CD Libint2::cxx INTERFACE_COMPILE_DEFINITIONS)
            string(REPLACE "=" " " LI_CD ${LI_CD})
            separate_arguments(LI_CD UNIX_COMMAND ${LI_CD})
            list (GET LI_CD 1 LI_BASIS_SET_PATH)
            file(GLOB _CMSB_BASISSET_FILES "${CMSB_BASISSET_DIR}/*")
            install(FILES ${_CMSB_BASISSET_FILES}
                    DESTINATION ${LI_BASIS_SET_PATH}/basis)
        endif()
    endif()

    ############################################################################
    #
    # Let the user know all the settings we worked out
    #
    ############################################################################

    print_banner("Summary of ${PROJECT_NAME} Configuration Settings:")
    message(STATUS "Found the following dependencies: ")
    foreach(__depend ${DEPENDS_WE_FOUND})
        message(STATUS "    ${__depend}")
    endforeach()
    message(STATUS "Will build the following dependencies: ")
    foreach(__depend ${DEPENDS_WERE_BUILDING})
        message(STATUS "    ${__depend}")
    endforeach()

    ############################################################################
    #
    # Make an uninstall target
    #
    ############################################################################
    # configure_file(
    #     "${CMSB_CMAKE}/cmake_uninstall.cmake.in"
    #     "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    #     IMMEDIATE @ONLY)

    #     add_custom_target(uninstall
    #             COMMAND ${CMAKE_COMMAND} -P
    #             ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endfunction()

