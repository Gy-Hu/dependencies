#!/bin/sh


if [ -z "$build" ] ; then 
  echo '$build is undefined'
  exit 1
fi
if [ -z "$package_dir" ] ; then 
  echo '$build is undefined'
  exit 1
fi


package=cudd
version=2.5.0
source=$package-$version.tar.gz
build_dir=$build/$package-$version
url=https://src.fedoraproject.org/repo/pkgs/cudd/cudd-2.5.0.tar.gz/8fec90d7ebd68563bddbe6c9331d92e6/cudd-2.5.0.tar.gz

download_unpack() {
  cd $build &&
  [ -f $source ] || wget -O $source $url &&
  tar -xzvf $source
}


pre_build() {
  cd $build_dir &&
  install_cmake_files
}

build_install() {
  if [ -z "$target" ] ; then 
    echo '$target is undefined'
    exit 1
  fi
  cd $build_dir &&
  mkdir -p build &&
  cd build &&
  cmake .. -DCMAKE_INSTALL_PREFIX=$target &&
  make install
}
