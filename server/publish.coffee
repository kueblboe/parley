Meteor.publish "topics", ->
  me = Meteor.users.findOne(@userId)
  if me
    Lists.find {domain: me.domain}
  else
    Lists.find {domain: {$exists: false}}

Meteor.publish "todos", (listId) ->
  check listId, String
  Todos.find {listId: listId, text: {$ne: ""}}

Meteor.publish "myTodos", (listId) ->
  if @userId
    Todos.find {listId: listId, userId: @userId}
  else
    @ready()

Meteor.publish "coworkers", ->
  me = Meteor.users.findOne(@userId)
  if me
    Meteor.users.find({ 'domain': me.domain })
  else
    @ready()
