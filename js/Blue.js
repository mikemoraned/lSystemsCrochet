// Generated by CoffeeScript 1.6.1
(function() {
  var Blue,
    _this = this;

  Blue = (function() {

    Blue.NEXT_ID = 10000;

    function Blue() {
      var _this = this;
      this.accept = function(visitor) {
        return Blue.prototype.accept.apply(_this, arguments);
      };
      this.grow = function() {
        return Blue.prototype.grow.apply(_this, arguments);
      };
      this.color = "0000FF";
      this.id = Blue.NEXT_ID;
      Blue.NEXT_ID++;
      this.children = [];
    }

    Blue.prototype.grow = function() {
      return this.children = [new Blue(), new Red()];
    };

    Blue.prototype.accept = function(visitor) {
      return visitor.visit(this, this.children);
    };

    return Blue;

  })();

  window.Blue = Blue;

}).call(this);
