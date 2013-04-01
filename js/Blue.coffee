class Blue

  @NEXT_ID : 10000

  constructor: ->
    @color = "blue"
    @id = Blue.NEXT_ID
    Blue.NEXT_ID++
    console.log("Id: #{@id}")
    @children = []

  grow: () =>
    @children = [new Blue(), new Red()]

  accept: (visitor) =>
    visitor.visit(@, @children)

window.Blue = Blue
