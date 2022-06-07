cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(CMakeBuild-Tests VERSION ${PROJECT_VERSION} LANGUAGES CXX)
include(TargetMacros)

add_cmake_macro_test(TestAssertMacros)
add_cmake_macro_test(TestUtilityMacros)
# add_cmsb_test(TestBuildCereal)
# add_cmsb_test(TestBuildEigen3)
# add_cmsb_test(TestBuildPybind11)
