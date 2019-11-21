conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())

constants_header = configure_file(
  input: 'configs/Constants.vala',
  output: 'Constants.vala',
  configuration: conf_data
)

hemera_sources = files(
  'configs/Settings.vala',
  'Application.vala',
  'MainWindow.vala',
  'PreferencesWindow.vala',
  'views/InitSplash.vala',
  'views/Setup.vala',
  'views/Installer.vala',
  'views/InstallationComplete.vala',
  'views/DisplayEnclosure.vala',
  'views/EnclosureFace.vala',
  'views/LightRingAnimator.vala',
  'views/MainDynamicButton.vala',
  'views/SuggestionBox.vala',
  'views/SuggestionArea.vala',
  'bubbles/EmptySpaceOverlay.vala',
  'bubbles/SVGData.vala',
  'bubbles/SpeechBubble.vala',
  'bubbles/QnABubble.vala',
  'bubbles/WeatherBubbleCurrent.vala',
  'core/AppEntry.vala',
  'core/AppDiscovery.vala',
  'core/AppSearch.vala',
  'core/LevenshteinDistanceSearch.vala',
  'core/MycroftManager.vala',
  'bubbles/AppBubble.vala',
  'views/ChatView.vala',
)

hemera_sources += constants_header
