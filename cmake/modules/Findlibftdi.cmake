# Copyright 2009  SoftPLC Corporation  http://softplc.com
# Dick Hollenbeck <d...@softplc.com>
# License: GPL v2
#
# - Try to find libftdi
#
# Before calling, USE_STATIC_FTDI may be set to mandate a STATIC library
#
# Once done this will define
#
# LIBFTDI_FOUND - system has libftdi
# LIBFTDI_INCLUDE_DIR - the libftdi include directory
# LIBFTDI_LIBRARIES - Link these to use libftdi


if (NOT LIBFTDI_FOUND)

  if(NOT WIN32)
    include(FindPkgConfig)
    pkg_check_modules(LIBFTDI_PKG libftdi1)
  endif(NOT WIN32)

  find_path(LIBFTDI_INCLUDE_DIR
    NAMES
    ftdi.h
    HINTS
    ${LIBFTDI_PKG_INCLUDE_DIRS}
    PATHS
    /usr/include
    /usr/local/include
    /usr/local/include/libftdi1
    )

  if(USE_STATIC_FTDI)
    set(_save ${CMAKE_FIND_LIBRARY_SUFFIXES})
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
  endif(USE_STATIC_FTDI)

  find_library(LIBFTDI_LIBRARIES
    NAMES
    ftdi
    HINTS
    ${LIBFTDI_PKG_LIBRARY_DIRS}
    PATHS
    /usr/lib
    /usr/local/lib
    /usr/local/lib/libftdi1
    )

  if(USE_STATIC_FTDI)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_save} )
  endif(USE_STATIC_FTDI)
  include(FindPackageHandleStandardArgs)

  # handle the QUIETLY AND REQUIRED arguments AND set LIBFTDI_FOUND to TRUE if
  # all listed variables are TRUE
  find_package_handle_standard_args(LIBFTDI DEFAULT_MSG LIBFTDI_LIBRARIES LIBFTDI_INCLUDE_DIR)

  if(USE_STATIC_FTDI)
    add_library(libftdi1 STATIC IMPORTED)
  else(USE_STATIC_FTDI)
    add_library(libftdi1 SHARED IMPORTED)
    target_include_directories(libftdi1 INTERFACE ${LIBFTDI_INCLUDE_DIR})
  endif(USE_STATIC_FTDI)

  set_target_properties(libftdi1 PROPERTIES IMPORTED_LOCATION ${LIBFTDI_LIBRARIES})
  set(${LIBFTDI_LIBRARIES} libftdi1)

  #mark_as_advanced(LIBFTDI_INCLUDE_DIR LIBFTDI_LIBRARIES)

  endif(NOT LIBFTDI_FOUND)
