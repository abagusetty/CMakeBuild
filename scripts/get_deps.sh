#!/bin/bash

export cdir=`pwd`

echo "Replace L20-21 in TAMM/CMakeLists.txt with: URL $cdir/CMakeBuild"
git clone https://github.com/NWChemEx-Project/CMakeBuild.git
cd CMakeBuild

cd $cdir

git clone https://github.com/wavefunction91/linalg-cmake-modules.git

git clone https://github.com/flame/blis.git
cd blis
git checkout 60f36347c16e6336215cd52b4e5f3c0f96e7c253

cd $cdir

wget https://github.com/doctest/doctest/archive/refs/tags/v2.4.9.tar.gz

git clone https://gitlab.com/libeigen/eigen.git
cd eigen
git checkout e887196d9d67e48c69168257d599371abf1c3b31

cd $cdir

git clone https://github.com/GlobalArrays/ga.git
cd ga
git checkout develop

cd $cdir
wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_14_0.tar.gz

git clone https://github.com/ajaypanyala/hptt.git
cd hptt
git checkout aee625b2e51ede30a3b5edf50d159452e7839d95

cd $cdir
wget https://github.com/evaleev/libint/releases/download/v2.7.2/libint-2.7.2.tgz

git clone https://github.com/victor-anisimov/Librett.git

git clone https://github.com/Microsoft/GSL.git
cd GSL
git checkout 3ba80d5dd465828909e1ee756b8c437d5e820ccc

cd $cdir

git clone https://github.com/nlohmann/json.git
cd json
git checkout b2306145e1789368e6f261680e8dc007e91cc986

cd $cdir

git clone git clone https://github.com/gabime/spdlog
cd spdlog
# git checkout v1.x

cd $cdir

git clone https://github.com/Reference-LAPACK/lapack.git
cd lapack
git checkout eb8f5fa6462a483431c258f4d6831aa3d4192771

cd $cdir
git clone https://github.com/Reference-ScaLAPACK/scalapack.git
cd scalapack
git checkout 2072b8602f0a5a84d77a712121f7715c58a2e80d

cd $cdir

git clone https://bitbucket.org/icl/blaspp.git
cd blaspp 
git checkout e6a87207af24783270026e476c77d47e1ae3dcc0

cd $cdir
git clone https://bitbucket.org/icl/lapackpp.git
cd lapackpp
git checkout 02ecd1250740579301844c00a61504d66a39c5d0

cd $cdir
git clone https://github.com/wavefunction91/scalapackpp
cd scalapackpp
git checkout 6397f52cf11c0dfd82a79698ee198a2fce515d81
cd $cdir


