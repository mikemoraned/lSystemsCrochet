
class Visitor

  constructor: (@posMap, @nodes, @links) ->


  visit: (parent, children) =>
    parentPos = @posMap[parent.id]
    if not parentPos?
      parentPos = @nodes.length
      @nodes.push(parent)
      @posMap[parent.id] = parentPos
    else
      @nodes.push(parent)
    console.log("posMap:")
    console.dir(@posMap)
    console.log("id #{parent.id} -> #{parentPos}")
    for child in children
      child.accept(@)
      childPos = @posMap[child.id]
      console.log("parent -> child: #{parentPos} -> #{childPos}")
      link = {}
      link.source = parentPos
      link.target = childPos
      console.log("link to child #{child.id}:")
      console.dir(link)
      @links.push(link)

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
    @posMap = {}
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

    visitor = new Visitor(@posMap, nodes, links)
    for root in @roots
      root.accept(visitor)

    console.dir(nodes)
    console.dir(links)

    [nodes,links]

window.Layout = Layout