class Layout

  constructor: (@width, @height, @selector)->
#    @roots = [new Blue()]
    # BGBBGG
    @roots = [new Blue(), new Red(), new Blue(), new Blue(), new Red(), new Red()]
    @outerLayer = @roots

  grow: =>
    console.log("Grow!")

    growth = []
    firstChild = null
    lastChild = null
    for parent in @outerLayer
      for child in parent.grow()
        @_newParticle()
#        if not firstChild?
#          firstChild = child
#        @nodes.push(child)
#        @links.push({ source: parent, target: child })
#        if lastChild?
#          @links.push({ source: lastChild, target: child, strength: 0.5 })
        growth.push(child)
#        lastChild = child
#    @links.push({ source: lastChild, target: firstChild, strength: 0.5 })
    @outerLayer = growth
#    @_redraw()

  _newParticle: () =>
    center = new Vector @width * Math.random(), @height * Math.random()

    p = new Particle 6.0
    p.colour = 'DC0048'
    p.moveTo center
    p.setRadius 10.0

    p.behaviours.push @edge
    p.behaviours.push @wander

    @physics.particles.push p

  start: () =>
    @_setup()
    @_redraw()

  _setup: () =>
    @physics = new Physics()
    @height = window.innerHeight
    @width = window.innerWidth

    @stiffness = 1.0
    @spacing = 2.0

    @physics.integrator = new Verlet()
    @physics.viscosity = 0.0001

    gap = 50.0
    min = new Vector -gap, -gap
    max = new Vector @width + gap, @height + gap

    @edge = new EdgeBounce min, max
    @wander = new Wander 0.05, 100.0, 80.0

    center = new Vector @width * 0.5, @height * 0.5

    console.dir(center)

#    for i in [0..100]
#      p = new Particle 6.0
#      p.colour = 'DC0048'
#      p.moveTo center
#      p.setRadius 10.0
#
#      p.behaviours.push edge
##      p.behaviours.push wander
#
#      @physics.particles.push p

#    @renderer = new WebGLRenderer()
    @renderer = new CanvasRenderer()

    container = $(@selector)
    container.get(0).appendChild @renderer.domElement

    @renderer.renderMouse = false
    @renderer.init @physics
    @renderer.setSize @width, @height

  _redraw: =>

    requestAnimationFrame(@_redraw)

#    console.log("Render")

#    console.dir(@physics.particles)

    do @physics.step

    @renderer.render @physics



window.Layout = Layout