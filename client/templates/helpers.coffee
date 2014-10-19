@userProfile = (userId) ->
  Meteor.users.findOne(userId)?.profile

UI.registerHelper "domain", ->
  Meteor.user()?.domain

UI.registerHelper "emailLocalPart", (userId) ->
  user = if userId then Meteor.users.findOne(userId) else Meteor.user()
  email = user.emails[0].address
  email.substring 0, email.indexOf("@")

UI.registerHelper "avatar", (userId) ->
  profile = userProfile(userId)
  if not userId? or not profile
    '/img/anonymous2.png'
  else if profile.avatar
    profile.avatar
  else
    '/img/anonymous.png'