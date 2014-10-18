# if the database is empty on server start, create some sample data.
Meteor.startup ->
  if Lists.find().count() is 0
    data = [
      {
        name: "Meteor Principles"
        items: [
          "Data on the Wire"
          "One Language"
          "Database Everywhere"
          "Latency Compensation"
          "Full Stack Reactivity"
          "Embrace the Ecosystem"
          "Simplicity Equals Productivity"
        ]
      }
      {
        name: "Languages"
        items: [
          "Lisp"
          "C"
          "C++"
          "Python"
          "Ruby"
          "JavaScript"
          "Scala"
          "Erlang"
          "6502 Assembly"
        ]
      }
      {
        name: "Favorite Scientists"
        items: [
          "Ada Lovelace"
          "Grace Hopper"
          "Marie Curie"
          "Carl Friedrich Gauss"
          "Nikola Tesla"
          "Claude Shannon"
        ]
      }
    ]
    timestamp = (new Date()).getTime()
    _.each data, (list) ->
      list_id = Lists.insert(name: list.name)
      _.each list.items, (text) ->
        Todos.insert
          listId: list_id
          text: text
          createdAt: new Date(timestamp)

        timestamp += 1 # ensure unique timestamp.

