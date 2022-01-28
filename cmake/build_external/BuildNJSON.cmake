set(NJSON_GIT_TAG b5364faf9d732052506cefc933d3f4e4f04513a5)
if(ENABLE_DEV_MODE)
  set(NJSON_GIT_TAG develop)
endif()

ExternalProject_Add(NJSON_External
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG ${NJSON_GIT_TAG}
    UPDATE_DISCONNECTED 1    
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DJSON_BuildTests=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

