class Red
  @NEXT_ID : 0

  constructor: ->
    @color = "red"
    @id = Red.NEXT_ID
    Red.NEXT_ID++
    console.log("Id: #{@id}")
    @children = []

  grow: () =>
    @children = [new Blue()]

  accept: (visitor) =>
    visitor.visit(@, @children)

window.Red = Red