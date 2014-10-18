@Lists = new Meteor.Collection("lists")

# Calculate a default name for a list in the form of 'Topic A'
Lists.defaultName = ->
  nextLetter = "A"
  nextName = "Topic " + nextLetter
  while Lists.findOne(name: nextName)
    
    # not going to be too smart here, can go past Z
    nextLetter = String.fromCharCode(nextLetter.charCodeAt(0) + 1)
    nextName = "Topic " + nextLetter
  nextName

@Todos = new Meteor.Collection("todos")