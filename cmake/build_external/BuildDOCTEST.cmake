include(${CMAKE_CURRENT_LIST_DIR}/dep_versions.cmake)

if(ENABLE_OFFLINE_BUILD)
ExternalProject_Add(DOCTEST_External
    URL ${DEPS_LOCAL_PATH}/v${CMSB_DOCTEST_VERSION}.tar.gz
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DDOCTEST_WITH_TESTS=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )
else()
ExternalProject_Add(DOCTEST_External
    URL https://github.com/doctest/doctest/archive/refs/tags/v${CMSB_DOCTEST_VERSION}.tar.gz
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DDOCTEST_WITH_TESTS=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )
endif()

