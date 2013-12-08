class Blue

  @NEXT_ID : 10000

  constructor: (@parent = null) ->
    @color = "blue"
    @id = Blue.NEXT_ID
    Blue.NEXT_ID++
    console.log("Id: #{@id}")
    @children = []

  grow: () =>
    @children = [new Blue(this), new Red(this)]

window.Blue = Blue
