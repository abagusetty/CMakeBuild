CMakeBuild_Test Directory
===========================

This directory contains a series of unit tests to ensure that CMakeBuild is
working correctly.  See the documentation for the various `add_X_test`s 
contained in `CMakeLists.txt` for information and syntax regarding adding new
tests.  

The following tests strive to ensure that our CMake macros work 
correctly:

1. TestAssertMacros
2. TestUtilityMacros

The following tests ensure we can build dependencies and that the project is 
provided the proper includes/libraries for compiling.  The names of the tests
should make the feature they test self explanatory...

1. TestBuildEigen3
2. TestBuildLibInt


