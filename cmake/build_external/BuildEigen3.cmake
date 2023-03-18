set(EIGEN_GIT_TAG e887196d9d67e48c69168257d599371abf1c3b31) #Mar 17, 2023
if(ENABLE_DEV_MODE)
    set(EIGEN_GIT_TAG master)
endif()

ExternalProject_Add(Eigen3_External
    GIT_REPOSITORY https://gitlab.com/libeigen/eigen.git
    GIT_TAG ${EIGEN_GIT_TAG}
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} 
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install #DESTDIR=${STAGE_DIR}
    )

