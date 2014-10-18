capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.substring(1).toLowerCase() if string

secondLevelDomain = (string) ->
  string.match(/[^\.\@]*\.[a-zA-Z]{2,}$/)[0]

createFirstTopicIfNoneExists = (domain) ->
  unless Lists.findOne({domain: domain})
    Lists.insert({domain: domain, name: "internal"})

Accounts.emailTemplates.siteName = "Parley"
Accounts.emailTemplates.from = "Manuel <manuel@qualityswdev.com>"
Accounts.emailTemplates.resetPassword.text = (user, url) ->
  "Please follow this link to reset your password:\n\n#{url}"
Accounts.emailTemplates.verifyEmail.subject = ->
  "Welcome to " + Accounts.emailTemplates.siteName

Accounts.urls.resetPassword = (token) ->
  Meteor.absoluteUrl "recovery/" + token

Accounts.urls.verifyEmail = (token) ->
  Meteor.absoluteUrl "verify-email/" + token

Accounts.onCreateUser (options, user) ->
  if user.services.password
    [email_name, domain] = user.emails[0].address.split('@')
    [firstname, middlenames..., lastname] = email_name.split('.')
    user.profile =
      firstname: capitalize(firstname)
      lastname: capitalize(lastname)
      avatar: Gravatar.imageUrl(user.emails[0].address, {d: 'monsterid'})
    user.domain = secondLevelDomain(domain)
    createFirstTopicIfNoneExists(user.domain)
  user

Accounts.validateLoginAttempt (attempt) ->
  if attempt.user and attempt.user.emails and not attempt.user.emails[0].verified
    Accounts.sendVerificationEmail(attempt.user._id)
    throw new Meteor.Error("unverified email", "We need you to verify your email address before we can let you in. We just sent you an email. Please check your email inbox and follow the link in the email.")
  true