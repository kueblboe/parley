# check that the userId specified owns the documents
@ownsDocument = (userId, doc) ->
  doc and doc.userId is userId

@isInDomain = (userId, doc) ->
  doc and doc.domain is Meteor.user().domain