#!/bin/bash

path_apt_sourcelist=/etc/apt/sources.list
path_assimp_repo=/tmp/assimp
path_assimp_build="${path_assimp_repo}/build"

if ! grep -q "apt.llvm.org" ${path_apt_sourcelist}; then
	bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
fi

apt install -y git cmake ninja-build

if [ ! -d ${path_assimp_repo} ]; then
#	git clone --depth 1 --branch v5.1.0 https://github.com/assimp/assimp.git ${path_assimp_repo}
	git clone https://github.com/assimp/assimp.git ${path_assimp_repo}
	cd ${path_assimp_repo}
# first green commit after release of 5.2.0, git tag does not exist...
	git checkout 91737f1cc936011785c110e3227db20677a3e4c9
fi

if [ ! -d ${path_assimp_build} ]; then
  mkdir ${path_assimp_build}
	# shellcheck disable=SC2164
	cd ${path_assimp_build}
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/usr/bin/clang++-13 -DCMAKE_C_COMPILER=/usr/bin/clang-13 -DCMAKE_INSTALL_PREFIX=/usr/local -G Ninja ..
	ninja
	ninja install
fi