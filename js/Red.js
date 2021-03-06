// Generated by CoffeeScript 1.6.3
(function() {
  var Red,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Red = (function() {
    Red.NEXT_ID = 0;

    function Red(parent) {
      this.parent = parent != null ? parent : null;
      this.grow = __bind(this.grow, this);
      this.color = "red";
      this.id = Red.NEXT_ID;
      Red.NEXT_ID++;
      console.log("Id: " + this.id);
      this.children = [];
    }

    Red.prototype.grow = function() {
      return this.children = [new Blue(this)];
    };

    return Red;

  })();

  window.Red = Red;

}).call(this);

/*
//@ sourceMappingURL=Red.map
*/
