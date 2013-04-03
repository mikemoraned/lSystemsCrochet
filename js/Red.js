// Generated by CoffeeScript 1.6.1
(function() {
  var Red,
    _this = this;

  Red = (function() {

    Red.NEXT_ID = 0;

    function Red() {
      var _this = this;
      this.accept = function(visitor) {
        return Red.prototype.accept.apply(_this, arguments);
      };
      this.grow = function() {
        return Red.prototype.grow.apply(_this, arguments);
      };
      this.color = "FF0000";
      this.id = Red.NEXT_ID;
      Red.NEXT_ID++;
      this.children = [];
    }

    Red.prototype.grow = function() {
      return this.children = [new Blue()];
    };

    Red.prototype.accept = function(visitor) {
      return visitor.visit(this, this.children);
    };

    return Red;

  })();

  window.Red = Red;

}).call(this);
