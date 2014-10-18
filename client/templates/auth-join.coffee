ERRORS_KEY = "joinErrors"

Template.join.created = ->
  Session.set ERRORS_KEY, {}

Template.join.helpers
  errorMessages: ->
    _.values Session.get(ERRORS_KEY)

  errorClass: (key) ->
    Session.get(ERRORS_KEY)[key] and "error"

Template.join.events submit: (event, template) ->
  event.preventDefault()
  email = template.$("[name=email]").val()
  password = template.$("[name=password]").val()
  errors = {}
  errors.email = "Email required"  unless email
  errors.password = "Password required"  unless password
  Session.set ERRORS_KEY, errors
  return  if _.keys(errors).length

  Accounts.createUser {email: email, password: password}, (error) ->
    if error
      Session.set(ERRORS_KEY, none: error.reason)
    else
      Router.go "home"
