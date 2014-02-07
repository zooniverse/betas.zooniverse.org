BaseController = require 'zooniverse/controllers/base-controller'

class NotSignedIn extends BaseController
  className: 'not-signed-in'
  template: require '../views/not-signed-in'

  events:
    'click .sign-in': 'onSignIn'

  constructor: ->
    super

  onSignIn: (e) ->
    e.preventDefault()
    require('zooniverse/controllers/login-dialog').show()

module.exports = NotSignedIn
