set(NJSON_GIT_TAG 8fcdbf2e771f481d988cb36847d6af6b17e30a99)
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

