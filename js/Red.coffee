class Red
  @NEXT_ID : 0

  constructor: (@parent = null) ->
    @color = "red"
    @id = Red.NEXT_ID
    Red.NEXT_ID++
    console.log("Id: #{@id}")
    @children = []

  grow: () =>
    @children = [new Blue(this)]

window.Red = Red