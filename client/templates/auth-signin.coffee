ERRORS_KEY = "signinErrors"

Template.signin.created = ->
  Session.set ERRORS_KEY, {}

Template.signin.helpers
  errorMessages: ->
    _.values Session.get(ERRORS_KEY)

  errorClass: (key) ->
    Session.get(ERRORS_KEY)[key] and "error"

Template.signin.events submit: (event, template) ->
  event.preventDefault()
  email = template.$("[name=email]").val()
  password = template.$("[name=password]").val()
  errors = {}
  errors.email = "Email is required"  unless email
  errors.password = "Password is required"  unless password
  Session.set ERRORS_KEY, errors
  return  if _.keys(errors).length
  
  Meteor.loginWithPassword email, password, (error) ->
    if error
      Session.set(ERRORS_KEY, none: error.reason)
    else
      Router.go "home"
