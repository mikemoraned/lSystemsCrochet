// Generated by CoffeeScript 1.6.3
(function() {
  var Layout,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Layout = (function() {
    function Layout(width, height, selector) {
      this.width = width;
      this.height = height;
      this.selector = selector;
      this._redraw = __bind(this._redraw, this);
      this._setup = __bind(this._setup, this);
      this.grow = __bind(this.grow, this);
      this.roots = [new Blue(), new Red(), new Blue(), new Blue(), new Red(), new Red()];
      this.outerLayer = this.roots;
      this._setup();
      this._redraw();
    }

    Layout.prototype.grow = function() {
      var child, firstChild, growth, lastChild, parent, _i, _j, _len, _len1, _ref, _ref1;
      console.log("Grow!");
      growth = [];
      firstChild = null;
      lastChild = null;
      _ref = this.outerLayer;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parent = _ref[_i];
        _ref1 = parent.grow();
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          child = _ref1[_j];
          if (firstChild == null) {
            firstChild = child;
          }
          this.nodes.push(child);
          this.links.push({
            source: parent,
            target: child
          });
          if (lastChild != null) {
            this.links.push({
              source: lastChild,
              target: child,
              strength: 0.5
            });
          }
          growth.push(child);
          lastChild = child;
        }
      }
      this.links.push({
        source: lastChild,
        target: firstChild,
        strength: 0.5
      });
      this.outerLayer = growth;
      return this._redraw();
    };

    Layout.prototype._setup = function() {
      var i, _i, _ref,
        _this = this;
      this.svg = d3.select(this.selector);
      this.nodes = this.outerLayer;
      this.links = [];
      if (this.outerLayer.length > 1) {
        for (i = _i = 0, _ref = this.outerLayer.length - 1; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          this.links.push({
            source: this.outerLayer[i],
            target: this.outerLayer[i + 1]
          });
        }
        this.links.push({
          source: this.outerLayer[this.outerLayer.length - 1],
          target: this.outerLayer[0]
        });
      }
      this.force = d3.layout.force().nodes(this.nodes).links(this.links).size([this.width, this.height]).start();
      return this.force.on("tick", function() {
        _this.svg.selectAll(".link").data(_this.links).attr("x1", function(d) {
          return d.source.x;
        }).attr("y1", function(d) {
          return d.source.y;
        }).attr("x2", function(d) {
          return d.target.x;
        }).attr("y2", function(d) {
          return d.target.y;
        });
        return _this.svg.selectAll(".node").data(_this.nodes).attr("cx", function(d) {
          return d.x;
        }).attr("cy", function(d) {
          return d.y;
        });
      });
    };

    Layout.prototype._redraw = function() {
      var link, node;
      this.force.nodes(this.nodes).links(this.links).start();
      link = this.svg.selectAll(".link").data(this.links).enter().append("line").attr("class", "link");
      return node = this.svg.selectAll(".node").data(this.nodes, function(d) {
        return d.id;
      }).enter().append("circle").attr("class", function(d) {
        return "node " + d.color;
      }).attr("r", 15).call(this.force.drag);
    };

    return Layout;

  })();

  window.Layout = Layout;

}).call(this);
