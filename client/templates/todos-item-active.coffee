Template.todosItemActive.events
  "blur textarea": (event) ->
    if event.target.value isnt ""
      Todos.update @_id,
        $set:
          finalized: true
          createdAt: new Date()
      Todos.insert
        listId: @listId
        text: ""
        userId: Meteor.userId()
        createdAt: new Date(9999,1,1)

  "keydown textarea": (event) ->
    # ESC or ENTER
    if event.which is 27 or event.which is 13
      event.preventDefault()
      event.target.blur()

  # update the text of the item on keypress but throttle the event to ensure
  # we don't flood the server with updates (handles the event at most once 
  # every 300ms)
  "keyup textarea": _.throttle((event) ->
    Todos.update @_id,
      $set:
        text: event.target.value
  , 300)
