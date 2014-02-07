BaseController = require 'zooniverse/controllers/base-controller'
User = require 'zooniverse/models/user'

CLASS_STATE = 'toggle-on'

class PreferenceToggle extends BaseController
  className: 'preference-toggle'
  template: require '../views/preference-toggle'

  key: false
  state: false

  elements:
    'input': 'inputRadio'

  events:
    'click': 'onChangePreference'

  constructor: ->
    super

    unless typeof @key is 'string' then return new TypeError 'Preference key must be provided and be a string.'

    @state = (User.current?.preferences?[@key] is "true")
    @updateUi()

  onChangePreference: =>
    @state = !@state
    @updateUi()

    User.current?.setPreference @key, @state, true

  updateUi: =>
    @el.toggleClass CLASS_STATE, @state
    @inputRadio.prop 'checked', @state

module.exports = PreferenceToggle
