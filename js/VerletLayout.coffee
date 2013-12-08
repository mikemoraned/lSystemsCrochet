class VerletLayout

  constructor: (@selector)->
#    @roots = [new Blue()]
    # BGBBGG
    @roots = [new Blue(), new Red(), new Blue(), new Blue(), new Red(), new Red()]
    @outerLayer = @roots
    @generations = 1
    @_setup()
    @_redraw()

  grow: =>
    console.log("Grow!")
    growth = []
#    firstChild = null
#    lastChild = null
    for parent in @outerLayer
      for child in parent.grow()
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
    @generations++
    @_redraw()

  _setup: () =>
    console.log("setup")

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
    @sim.friction = 0.3
    @sim.gravity = new Vec2(0.0, 0.0)

    # starting entities
    @origin = new Vec2(width/2, height/2)

    @sim.composites.push(@_placeInCircleAroundOrigin(@generations * 8.0, @outerLayer))

    # animation loop
    @_loop()

  _loop: () =>
    @sim.frame(16)
    @sim.draw()
    window.requestAnimFrame(@_loop)

  _redraw: =>
    console.log("redraw")
    @sim.composites.push(@_placeInCircleAroundOrigin(@generations * 8.0, @outerLayer))
    @sim.composites.push(@_attachToParents(8.0, @outerLayer))

  _placeInCircleAroundOrigin: (radius, nodes) =>
    layerComposite = new VerletJS.Composite()
    firstParticle = null
    lastParticleAdded = null
    count = 0
    thetaInc = (Math.PI * 2.0) / nodes.length
    circumferenceSeparation = ((Math.PI * 2.0) * radius) / nodes.length

    stiffness = 0.01

    for node in nodes
      node.particle = new Particle(@origin.add(new Vec2(radius * Math.sin(count * thetaInc), radius * Math.cos(count * thetaInc))))
      node.particle.lSystemNode = node
      layerComposite.particles.push(node.particle)
      if lastParticleAdded?
        layerComposite.constraints.push(new DistanceConstraint(lastParticleAdded, node.particle, stiffness, circumferenceSeparation))
      else
        firstParticle = node.particle
      lastParticleAdded = node.particle
      count += 1

    layerComposite.constraints.push(new DistanceConstraint(lastParticleAdded, firstParticle, stiffness, circumferenceSeparation))

    layerComposite.drawParticles = @_colorFromNode

    layerComposite

  _colorFromNode: (ctx, composite) =>
    for particle in composite.particles
      ctx.beginPath()
      ctx.arc(particle.pos.x, particle.pos.y, 1.3, 0, 2*Math.PI)
      ctx.fillStyle = particle.lSystemNode.color
      ctx.fill()

  _attachToParents: (offset, nodes) =>
    linkComposite = new VerletJS.Composite()
    stiffness = 0.1

    for node in nodes
      if node.parent?
        linkComposite.constraints.push(new DistanceConstraint(node.particle, node.parent.particle, stiffness, offset))

    linkComposite.drawConstraints = () =>

    linkComposite

window.VerletLayout = VerletLayout