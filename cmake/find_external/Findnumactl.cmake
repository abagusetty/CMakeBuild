# - Try to find numactl
#
#  Once done this will define
#  numactl_FOUND - System has numactl
#  numactl_INCLUDE_DIR - The numactl include directories
#  numactl_LIBRARY - The libraries needed to use numactl

# include(DependencyMacros)

set(NUMACTL_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

set( numactl_LIBRARY_NAME numa )

find_path(numactl_INCLUDE_DIR numa.h
            HINTS ${NUMACTL_HINTS}
            PATHS ${NUMACTL_ROOT}
            PATH_SUFFIXES include
            NO_DEFAULT_PATH
          )

find_library(numactl_LIBRARY 
             NAMES ${numactl_LIBRARY_NAME}
             HINTS ${NUMACTL_HINTS}
             PATHS ${NUMACTL_ROOT}
             PATH_SUFFIXES lib lib32 lib64
             NO_DEFAULT_PATH
        )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(numactl 
                              REQUIRED_VARS numactl_LIBRARY numactl_INCLUDE_DIR
                              HANDLE_COMPONENTS)

if(numactl_FOUND)
  set(NUMACTL_LIBRARIES ${numactl_LIBRARY})
  set(NUMACTL_INCLUDE_DIRS ${numactl_INCLUDE_DIR})
  message(STATUS "NUMACTL_LIBRARIES = ${NUMACTL_LIBRARIES}")
  if( NUMACTL_LIBRARIES AND NOT TARGET numactl-cmsb )
      add_library( numactl-cmsb INTERFACE IMPORTED )
      set_target_properties( numactl-cmsb PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES "${NUMACTL_INCLUDE_DIRS}"
          INTERFACE_LINK_LIBRARIES      "${NUMACTL_LIBRARIES}"
      )
  endif()
endif()
