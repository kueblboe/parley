Router.configure
  
  # we use the  appBody template to define the layout for the entire app
  layoutTemplate: "appBody"
  
  # the appNotFound template is used for unknown routes and missing lists
  notFoundTemplate: "appNotFound"
  
  # show the appLoading template whilst the subscriptions below load their data
  loadingTemplate: "appLoading"
  
  # wait on the following subscriptions before rendering the page to ensure
  # the data it's expecting is present
  waitOn: ->
    [
      Meteor.subscribe("coworkers")
      Meteor.subscribe("topics")
    ]

AccountController = RouteController.extend(
  verifyEmail: ->
    Accounts.verifyEmail @params.token, ->
      Router.go "home"
)

Router.map ->
  @route "join"
  @route "signin"

  @route "verifyEmail",
    controller: AccountController
    path: "/verify-email/:token"
    action: "verifyEmail"

  @route 'recovery',
    path: '/recovery/:token?',
    data: -> {token: if @params then @params.token else ''}

  @route "listsShow",
    path: "/lists/:_id"
    
    waitOn: ->
      Meteor.subscribe("todos", @params._id)
      Meteor.subscribe "myTodos", @params._id

    data: ->
      Lists.findOne @params._id

    onAfterAction: ->
      if @ready()
        unfinalizedTodo = Todos.findOne(
          userId: Meteor.userId()
          listId: @params._id
          finalized:
            $ne: true
        )
        unless unfinalizedTodo
          Todos.insert(
            listId: @params._id
            text: ""
            userId: Meteor.userId()
            createdAt: new Date(9999,1,1)
          )

  @route "home",
    path: "/"
    waitOn: ->
      Meteor.subscribe("coworkers")
      Meteor.subscribe("topics")

    action: ->
      Router.go "listsShow", Lists.findOne()

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
      pause()
    else
      @render "signin"
      pause()

Router.onBeforeAction requireLogin

if Meteor.isClient
  Router.onBeforeAction "loading",
    except: [
      "join"
      "signin"
    ]

  Router.onBeforeAction "dataNotFound",
    except: [
      "join"
      "signin"
    ]
