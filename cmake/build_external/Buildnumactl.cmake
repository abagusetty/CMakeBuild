include(${CMAKE_CURRENT_LIST_DIR}/dep_versions.cmake)

string_concat(CMAKE_C_FLAGS_RELEASE "" " " LNUMA_C_FLAGS)

if(CMAKE_POSITION_INDEPENDENT_CODE)
    set(FPIC_LIST "-fPIC")
    string_concat(FPIC_LIST "" " " LNUMA_C_FLAGS)
endif()

set(LNUMA_C_FLAGS "${LNUMA_C_FLAGS}")

ExternalProject_Add(numactl_External
    GIT_REPOSITORY https://github.com/numactl/numactl.git
    GIT_TAG ${NUMACTL_GIT_TAG}
    UPDATE_DISCONNECTED 1

    CONFIGURE_COMMAND ./autogen.sh COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX}
    CXX=${CMAKE_CXX_COMPILER}
    CC=${CMAKE_C_COMPILER}
    CFLAGS=${LNUMA_C_FLAGS}

    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    BUILD_IN_SOURCE 1
  )
