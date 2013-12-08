class VerletLayout

  constructor: (@selector)->
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
    console.log("setup")
    @nodes = @outerLayer
    @links = []

    canvas = document.getElementById(@selector)

    # canvas dimensions
    width = parseInt(canvas.style.width)
    height = parseInt(canvas.style.height)

    # retina
    dpr = window.devicePixelRatio || 1
    canvas.width = width*dpr
    canvas.height = height*dpr
    canvas.getContext("2d").scale(dpr, dpr)

    # simulation
    @sim = new VerletJS(width, height, canvas)
    @sim.friction = 1

    # entities
    segment = @sim.lineSegments([new Vec2(20,10), new Vec2(40,10), new Vec2(60,10), new Vec2(80,10), new Vec2(100,10)], 0.02)
    pin = segment.pin(0)
    pin = segment.pin(4)

    tire1 = @sim.tire(new Vec2(200,50), 50, 30, 0.3, 0.9)
    tire2 = @sim.tire(new Vec2(400,50), 70, 7, 0.1, 0.2)
    tire3 = @sim.tire(new Vec2(600,50), 70, 3, 1, 1)

    # animation loop
    @_loop()

  _loop: () =>
    @sim.frame(16)
    @sim.draw()
    window.requestAnimFrame(@_loop)


  _redraw: =>
    console.log("redraw")


window.VerletLayout = VerletLayout