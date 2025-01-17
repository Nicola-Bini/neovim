find_path(LIBVTERM_INCLUDE_DIR vterm.h)
find_library(LIBVTERM_LIBRARY vterm)

if(LIBVTERM_INCLUDE_DIR AND EXISTS "${LIBVTERM_INCLUDE_DIR}/vterm.h")
  file(STRINGS ${LIBVTERM_INCLUDE_DIR}/vterm.h VTERM_VERSION_MAJOR REGEX "#define VTERM_VERSION_MAJOR")
  string(REGEX MATCH "[0-9]+" VTERM_VERSION_MAJOR ${VTERM_VERSION_MAJOR})

  file(STRINGS ${LIBVTERM_INCLUDE_DIR}/vterm.h VTERM_VERSION_MINOR REGEX "#define VTERM_VERSION_MINOR")
  string(REGEX MATCH "[0-9]+" VTERM_VERSION_MINOR ${VTERM_VERSION_MINOR})

  set(VTERM_VERSION ${VTERM_VERSION_MAJOR}.${VTERM_VERSION_MINOR})
endif()

find_package_handle_standard_args(libvterm
  REQUIRED_VARS LIBVTERM_INCLUDE_DIR LIBVTERM_LIBRARY
  VERSION_VAR VTERM_VERSION)

add_library(libvterm INTERFACE)
target_include_directories(libvterm SYSTEM BEFORE INTERFACE INTERFACE ${LIBVTERM_INCLUDE_DIR})
target_link_libraries(main_lib INTERFACE ${LIBVTERM_LIBRARY})
