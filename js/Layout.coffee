
class Visitor

  constructor: (@nodes, @links) ->

  visit: (parent, children) =>
    @nodes.push(parent)
    for child in children
      child.accept(@)

class Layout

  constructor: (@width, @height, @selector)->
    @roots = [new Blue()]
    @outerLayer = @roots
    @_setup()
    @_redraw()

  grow: =>
    console.log("Grow!")
    growth = []
    for node in @outerLayer
      grown = node.grow()
      for grownNode in grown
        growth.push(grownNode)
    @outerLayer = growth
    @_redraw()

  _setup: () =>
    @svg = d3.select(@selector)
    [nodes, links] = @_traverse()
    @force = d3.layout.force()
      .nodes(nodes)
      .links(links)
      .size([@width, @height])
      .start()

  _redraw: =>
    [nodes, links] = @_traverse()
    @force
      .nodes(nodes)
      .links(links).start()

    link = @svg.selectAll(".link")
      .data(links)
      .enter().append("line")
      .attr("class", "link")

    node = @svg.selectAll(".node")
      .data(nodes, (d) -> d.id)
      .enter().append("circle")
      .attr("class", (d) -> "node #{d.color}")
      .attr("r", 5)
      .call(@force.drag)

    @force.on("tick", () ->
      link
        .attr("x1", (d) -> d.source.x )
        .attr("y1", (d) -> d.source.y )
        .attr("x2", (d) -> d.target.x )
        .attr("y2", (d) -> d.target.y )

      node
        .attr("cx", (d) -> d.x )
        .attr("cy", (d) -> d.y )
    )

  _traverse: () =>
    nodes = []
    links = []

    visitor = new Visitor(nodes, links)
    for root in @roots
      root.accept(visitor)

    console.dir(nodes)
    console.dir(links)

    [nodes,links]

window.Layout = Layout