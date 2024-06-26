################################################################################
#
# This file defines macros for common option manipulations.
#
################################################################################

#
# Sets an option's value if the user doesn't supply one.
#
# Syntax: option_w_default <name> <value>
#   - name: The name of the variable to store the option's value under,
#           e.g. CMAKE_BUILD_TYPE for the option containing the build's type
#   - value: The default value to set the variable to, e.g. to default to a
#            Debug build for the build type set value to Debug
#
function(option_w_default name value)
    is_valid(${name} was_set)
    if(was_set)
        message(STATUS "Value of ${name} was set by user to : ${${name}}")
    else()
        set(${name} ${value} PARENT_SCOPE)
        message(STATUS "Setting value of ${name} to default : ${value}")
    endif()
endfunction()

#
# Bundles a set of arguments up for passing them to external project add.  In
# particular this will remove empty arguments as those tend to cause problems in
# that many checks will mistakenly think that argument is set simply because it
# is defined.
#
# Syntax: bundle_cmake_args <out_var> <list>
#     - out_var : the variable that will contain the bundled list
#     - list    : the variables to bundle
#
function(bundle_cmake_args __out_var)
    foreach(__arg ${ARGN})
        is_valid(${__arg} not_empty)
        if(not_empty)
            list(APPEND ${__out_var} -D${__arg}=${${__arg}})
        endif()
    endforeach()
    set(${__out_var} ${${__out_var}} PARENT_SCOPE)
endfunction()

#
# Similar to bundle_cmake_args, but bundles them as strings appropriate for
# passing to an external project's CMAKE_CACHE_ARGS
#
# Syntax: bundle_cmake_strings <out_var> <list>
#     - out_var : the variable that will contain the bundled list
#     - list    : the variables to bundle
#
function(bundle_cmake_strings __out_var)
    foreach(__arg ${ARGN})
        is_valid(${__arg} not_empty)
        if(not_empty)
            list(APPEND ${__out_var} -D${__arg}:STRING=${${__arg}})
        endif()
    endforeach()
    set(${__out_var} ${${__out_var}} PARENT_SCOPE)
endfunction()

#
# Similar to bundle_cmake_args, but bundles them as lists appropriate for
# passing to an external project's CMAKE_CACHE_ARGS
#
# Syntax: bundle_cmake_list <out_var> <list>
#     - out_var : the variable that will contain the bundled list
#     - list    : the variables to bundle
#
function(bundle_cmake_list __out_var)
    foreach(__arg ${ARGN})
        is_valid(${__arg} not_empty)
        if(not_empty)
            list(APPEND ${__out_var} -D${__arg}:LIST=${${__arg}})
        endif()
    endforeach()
    set(${__out_var} ${${__out_var}} PARENT_SCOPE)
endfunction()

function(cmsb_set_has_vars PROJECT_ENABLE_XYZ PROJECT_HAS_XYZ CMSB_HAS_XYZ)
    set(${PROJECT_HAS_XYZ} FALSE CACHE BOOL "" FORCE)
    mark_as_advanced(FORCE ${PROJECT_HAS_XYZ})
    
    if(${PROJECT_ENABLE_XYZ})
        set(${PROJECT_HAS_XYZ} TRUE CACHE BOOL "" FORCE)
    endif()

    get_property(${CMSB_HAS_XYZ} CACHE ${PROJECT_HAS_XYZ} PROPERTY VALUE)

    set(${CMSB_HAS_XYZ} ${${CMSB_HAS_XYZ}} PARENT_SCOPE)
    set(${PROJECT_HAS_XYZ} ${${PROJECT_HAS_XYZ}} PARENT_SCOPE)
endfunction()
