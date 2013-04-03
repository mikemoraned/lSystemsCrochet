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
        @_newParticleFrom(child, parent)
        @_joinNodes(parent, child)
        if not firstChild?
          firstChild = child
        if lastChild?
          @_joinNodes(lastChild, child)
        growth.push(child)
        lastChild = child
#    @links.push({ source: lastChild, target: firstChild, strength: 0.5 })
    @_joinNodes(lastChild, firstChild)
    @outerLayer = growth
#    @_redraw()

  start: () =>
    @_setup()
    @_redraw()

  _setup: () =>
    @physics = new Physics()
    @height = window.innerHeight
    @width = window.innerWidth

    @stiffness = 0.1
    @spacing = 10.0

    @physics.integrator = new Verlet()
#    @physics.viscosity = 0.0001
    @physics.viscosity = 0.9

    gap = 50.0
    min = new Vector -gap, -gap
    max = new Vector @width + gap, @height + gap

    @edge = new EdgeBounce min, max
    @wander = new Wander 0.05, 100.0, 80.0
    @collision = new Collision()

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

    @_addInitialParticles()

  _newParticleFrom: (node, parent) =>
    center = new Vector @width * Math.random(), @height * Math.random()
    if parent?
      center = new Vector parent.particle.pos.x, parent.particle.pos.y

    p = new Particle 6.0
#    p.colour = 'DC0048'
    p.colour = node.color
    p.moveTo center
    p.setRadius 10.0

#    repulsion = new Attraction p.pos, 200, -200000

    p.behaviours.push @edge
#    p.behaviours.push @wander
    p.behaviours.push @collision
#    p.behaviours.push repulsion

    @collision.pool.push p

    @physics.particles.push p

    node.particle = p

  _addInitialParticles: () =>
    for initial in @outerLayer
      @_newParticleFrom(initial)
    if @outerLayer.length > 1
      for i in [0 ... @outerLayer.length - 1]
        @_joinNodes(@outerLayer[i], @outerLayer[i+1])
      @_joinNodes(@outerLayer[@outerLayer.length - 1], @outerLayer[0])

  _joinNodes: (parent, child) =>
    spring = new Spring parent.particle, child.particle, @spacing, @stiffness
    @physics.springs.push spring

  _redraw: =>

    requestAnimationFrame(@_redraw)

#    console.log("Render")

#    console.dir(@physics.particles)

    do @physics.step

    @renderer.render @physics



window.Layout = Layout