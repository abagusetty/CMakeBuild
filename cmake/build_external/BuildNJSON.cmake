set(NJSON_GIT_TAG 0b345b20c888f7dc8888485768e4bf9a6be29de0)
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

