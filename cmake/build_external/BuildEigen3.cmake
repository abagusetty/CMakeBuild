set(EIGEN_GIT_TAG 0fd6b4f71dd85b2009ee4d1aeb296e2c11fc9d68) #v3.3.9
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

