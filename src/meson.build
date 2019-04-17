conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())

constants_header = configure_file(
  input: 'configs/Constants.vala.in',
  output: 'Constants.vala',
  configuration: conf_data
)

hemera_sources = files(
  'Application.vala',
  'MainWindow.vala',
  'PreferencesWindow.vala',
  'views/InitSplash.vala',
  'views/DisplayEnclosure.vala',
  'views/MainDynamicButton.vala',
  'views/Suggestion.vala',
  'bubbles/SVGData.vala',
  'bubbles/SpeechBubble.vala',
  'bubbles/QnABubble.vala',
  'bubbles/WeatherBubbleCurrent.vala',
  'views/ChatView.vala',
)

hemera_sources += constants_header
