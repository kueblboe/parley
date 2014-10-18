@userProfile = (userId) ->
  Meteor.users.findOne(userId)?.profile

UI.registerHelper "domain", ->
  Meteor.user()?.domain

UI.registerHelper "avatar", (userId) ->
  profile = userProfile(userId)
  if not userId? or not profile
    '/img/anonymous2.png'
  else if profile.avatar
    profile.avatar
  else
    '/img/anonymous.png'