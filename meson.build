project(
  'com.github.SubhadeepJasu.hemera',
  ['c', 'vala'],
  version: '1.0.0',
  meson_version: '>= 0.46.0',
)

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

subdir('data')
subdir('po')
subdir('lib')
subdir('src')

hemera_deps = [
  dependency('gobject-2.0'),
  dependency('glib-2.0'),
  dependency('gtk+-3.0'),
  dependency('granite'),
  dependency('libarchive'),
  dependency('switchboard-2.0'),
  libhemera_dep
]

gnome = import('gnome')

hemera_sources += gnome.compile_resources(
  'hemera-resources',
  'data/com.github.SubhadeepJasu.hemera.gresource.xml',
  source_dir: 'data',
  c_name: 'hemera'
)

executable(
  'com.github.SubhadeepJasu.hemera',
  hemera_sources,
  vala_args: '--target-glib=2.50',
  dependencies: hemera_deps,
  install: true
)

meson.add_install_script('build-aux/meson/postinstall.py')
