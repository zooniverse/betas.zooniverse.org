$ = window.jQuery
$.noConflict()

Api = require 'zooniverse/lib/api'
api = new Api

enUs = require './lib/en-us'
translate = require 't7e'
LanguageManager = require 'zooniverse/lib/language-manager'

languageManager = new LanguageManager
  translations:
    en: label: 'English', strings: enUs

languageManager.on 'change-language', (e, code, strings) ->
  translate.load strings
  translate.refresh()

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.prependTo document.body

app = {}
app.container = '#app'
$(app.container).html require('./views/attempt-sign-in')

Spinner = require './lib/spin'
spinner = new Spinner({width: 3}).spin(document.querySelector app.container)

User = require 'zooniverse/models/user'
User.on 'change', (e, user) ->
  unless user
    $(app.container).html (new (require('./controllers/not-signed-in'))).el
    return

  spinner.stop()
  $(app.container).html('').prepend require './views/description'

  PreferenceToggle = require './controllers/preference-toggle'
  betaToggle = new PreferenceToggle
    key: 'beta_opt_in'

  $(app.container).append betaToggle.el

User.fetch()
