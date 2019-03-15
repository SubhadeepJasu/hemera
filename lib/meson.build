libhemera_sources = files(
  'Services/Connection.vala',
  'Services/MessageManager.vala',
)

libhemera_deps = [
  dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('libsoup-2.4'),
  dependency('json-glib-1.0'),
]

include_dir = join_paths(
  get_option('prefix'),
  get_option('includedir'),
  'libhemera'
)

libhemera = library(
  'libhemera',
  libhemera_sources,
  vala_args: '--target-glib=2.50',
  dependencies: libhemera_deps,
  install: true,
  vala_header: 'libhemera.h',
  vala_vapi: 'libhemera.vapi',
  version: meson.project_version(),
  install_dir: [true, include_dir, true],
)

install_data(
  'libhemera.deps',
  install_dir: join_paths(get_option('datadir'), 'vala', 'vapi')
)

libhemera_dep = declare_dependency(
  link_with: libhemera,
  dependencies: libhemera_deps,
  include_directories: [include_directories('.')],
)

pkgconfig = import('pkgconfig')

libhemera_pc = pkgconfig.generate(
  libhemera,
  name: 'libhemera',
  requires: libhemera_deps,
  subdirs: ['libhemera'],
  description: 'Hemera\'s lib for accessing the MyCroft backend',
  version: meson.project_version(),
  url: 'https://github.com/SubhadeepJasu/hemera',
)
