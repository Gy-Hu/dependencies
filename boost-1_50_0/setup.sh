#!/bin/sh

version=1_50_0

build_install() {
  if [ -z "$target" ] ; then
    echo '$target is undefined'
    exit 1
  fi

  if (( $(env python -c "import sys; print(sys.version_info[0])") > 2 )); then 
      if (( $(env python2 -c "import sys; print(sys.version_info[0])") == 2 )); then 
	  BOOTSTRAP_OPTS="--with-python=python2"
      fi
  fi

  COMMON_OPTS="
    --prefix=$target
    --layout=system
    variant=release
    link=shared
    toolset=gcc
  "
  LIBRARIES="
    --with-date_time
    --with-filesystem
    --with-graph
    --with-iostreams
    --with-math
    --with-program_options
    --with-python
    --with-random
    --with-regex
    --with-serialization
    --with-signals
    --with-system
    --with-thread
  "
  cd $build_dir &&
  mkdir -p build &&
  test -x bjam || ./bootstrap.sh $BOOTSTRAP_OPTS &&
  ./bjam -q $COMMON_OPTS $LIBRARIES install || {
    if [ ! -f /usr/include/zlib.h ] ; then
      echo 'zlib.h was not found.'
    fi
    if [ ! -f /usr/include/bzlib.h ] ; then
      echo 'bzlib.h was not found'
    fi
    PYTHON_NEEDED=`ls /usr/include/python*/Python.h &>/dev/null && echo false || echo true`
    if [ "$PYTHON_NEEDED" = "true" ] ; then
      echo 'Python.h was not found'
    fi
    echo "Install the packages containing the above header files to compile boost properly."
    exit 1
  }
}

# vim: ts=2 sw=2 et
