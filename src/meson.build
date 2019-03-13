conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())

constants_header = configure_file(
  input: 'configs/Constants.vala.in',
  output: 'Constants.vala',
  configuration: conf_data
)

hemera_sources = files(
  'Main.vala',
)

hemera_sources += constants_header