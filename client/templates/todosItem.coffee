Template.todosItem.helpers
  listName: ->
    Lists.findOne(@listId).name