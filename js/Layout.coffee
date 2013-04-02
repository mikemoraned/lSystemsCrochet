class Layout

  constructor: (@width, @height, @selector)->
#    @roots = [new Blue()]
    # BGBBGG
    @roots = [new Blue(), new Red(), new Blue(), new Blue(), new Red(), new Red()]
    @outerLayer = @roots
    @_setup()
    @_redraw()

  grow: =>
    console.log("Grow!")
    growth = []
    firstChild = null
    lastChild = null
    for parent in @outerLayer
      for child in parent.grow()
        if not firstChild?
          firstChild = child
        @nodes.push(child)
        @links.push({ source: parent, target: child })
        if lastChild?
          @links.push({ source: lastChild, target: child, strength: 0.5 })
        growth.push(child)
        lastChild = child
    @links.push({ source: lastChild, target: firstChild, strength: 0.5 })
    @outerLayer = growth
    @_redraw()

  _setup: () =>
    @svg = d3.select(@selector)
    @nodes = @outerLayer
    @links = []
    if @outerLayer.length > 1
      for i in [0 ... @outerLayer.length - 1]
        @links.push({ source: @outerLayer[i], target: @outerLayer[i+1] })
      @links.push({ source: @outerLayer[@outerLayer.length - 1], target: @outerLayer[0] })

    @force = d3.layout.force()
      .nodes(@nodes)
      .links(@links)
      .size([@width, @height])
      .start()

    @force.on("tick", () =>
      @svg.selectAll(".link")
        .data(@links)
        .attr("x1", (d) -> d.source.x )
        .attr("y1", (d) -> d.source.y )
        .attr("x2", (d) -> d.target.x )
        .attr("y2", (d) -> d.target.y )

      @svg.selectAll(".node")
        .data(@nodes)
        .attr("cx", (d) -> d.x )
        .attr("cy", (d) -> d.y )
    )

  _redraw: =>
    @force
      .nodes(@nodes)
      .links(@links).start()

    link = @svg.selectAll(".link")
      .data(@links)
      .enter().append("line")
      .attr("class", "link")

    node = @svg.selectAll(".node")
      .data(@nodes, (d) -> d.id)
      .enter().append("circle")
      .attr("class", (d) -> "node #{d.color}")
      .attr("r", 15)
      .call(@force.drag)

window.Layout = Layout