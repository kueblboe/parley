EDITING_KEY = "editingList"
Session.setDefault EDITING_KEY, false

Template.listsShow.rendered = ->
  @find(".js-title-nav")._uihooks =
    insertElement: (node, next) ->
      $(node).hide().insertBefore(next).fadeIn()

    removeElement: (node) ->
      $(node).fadeOut ->
        @remove()

Template.listsShow.helpers
  editing: ->
    Session.get EDITING_KEY

  unfinalizedPosts: ->
    Todos.find {listId: this._id, finalized: {$ne: true}}, {sort: {createdAt : -1}}

  finalizedPosts: ->
    Todos.find {listId: this._id, finalized: true}, {sort: {createdAt : -1}}


editList = (list, template) ->
  Session.set EDITING_KEY, true
  
  # force the template to redraw based on the reactive change
  Tracker.flush()
  template.$(".js-edit-form input[type=text]").focus()

saveList = (list, template) ->
  Session.set EDITING_KEY, false
  Lists.update list._id,
    $set:
      name: template.$("[name=name]").val()

deleteList = (list) ->
  # ensure the last public list cannot be deleted.
  return alert("Sorry, you cannot delete the final public topic!") if not list.domain and Lists.find(domain:
    $exists: false
  ).count() is 1
  message = "Are you sure you want to delete the topic " + list.name + "?"
  if confirm(message)
    # we must remove each item individually from the client
    Todos.find(listId: list._id).forEach (todo) ->
      Todos.remove todo._id

    Lists.remove list._id
    Router.go "home"
    true
  else
    false

Template.listsShow.events
  "click .js-cancel": ->
    Session.set EDITING_KEY, false

  "keydown input[type=text]": (event) ->
    # ESC
    if 27 is event.which
      event.preventDefault()
      $(event.target).blur()

  "blur input[type=text]": (event, template) ->
    # if we are still editing (we haven't just clicked the cancel button)
    saveList this, template  if Session.get(EDITING_KEY)

  "submit .js-edit-form": (event, template) ->
    event.preventDefault()
    saveList this, template
  
  # handle mousedown otherwise the blur handler above will swallow the click
  # on iOS, we still require the click event so handle both
  "mousedown .js-cancel, click .js-cancel": (event) ->
    event.preventDefault()
    Session.set EDITING_KEY, false

  "change .list-edit": (event, template) ->
    if $(event.target).val() is "edit"
      editList this, template
    else deleteList this, template  if $(event.target).val() is "delete"
    event.target.selectedIndex = 0

  "click .js-edit-list": (event, template) ->
    editList this, template

  "click .js-delete-list": (event, template) ->
    deleteList this, template
