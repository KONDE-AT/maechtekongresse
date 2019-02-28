/* HR.js | https://mburakerman.github.io/hrjs/ | @mburakerman | License: MIT */

var HR = function(el, options) {
  this.el = document.querySelectorAll(el);
  this.options = options || {};
}

HR.prototype.defaultOptions = {
  highlight: null,
  replaceWith: null
}


HR.prototype.bcolor = function(selector) {
  var data_hr = selector.querySelectorAll('[data-hr]');
  for (var i = 0; i < data_hr.length; i++) {
      data_hr[i].style.backgroundColor = this.defaultOptions.backgroundColor;
      if (typeof this.options.backgroundColor !== 'undefined') {
          data_hr[i].style.backgroundColor = this.options.backgroundColor
      }
  }
}


HR.prototype.hr = function() {
  for (var i = 0; i < this.el.length; i++) {

      if (typeof this.options.replaceWith === 'undefined' && typeof this.options.highlight !== 'undefined') {

          if (Array.isArray(this.options.highlight)) {
              for (var m = 0; m < this.options.highlight.length; m++) {
                  this.el[i].innerHTML = this.el[i].innerHTML.replace(new RegExp("(" + this.options.highlight[m] + ")", 'gi'), '<mark data-hr class="data-hr">$1</mark>')
              }
          } else {
              this.el[i].innerHTML = this.el[i].innerHTML.replace(new RegExp("(" + this.options.highlight + ")", 'i'), '<mark data-hr class="data-hr">$1</mark>')
          }

          this.bcolor(this.el[i]);
      }

      if ((typeof this.options.highlight !== 'undefined' && this.options.highlight !== null) && (typeof this.options.replaceWith !== 'undefined' && this.options.replaceWith !== null)) {

          if (Array.isArray(this.options.highlight) && Array.isArray(this.options.replaceWith)) {
              for (var n = 0; n < this.options.highlight.length; n++) {
                  if (typeof this.options.replaceWith[n] !== 'undefined') {
                      this.el[i].innerHTML = this.el[i].innerHTML.replace(new RegExp(this.options.highlight[n], 'gi'), '<mark data-hr class="data-hr">' + this.options.replaceWith[n] + '</mark>')
                  }
              }
          } else {
              this.el[i].innerHTML = this.el[i].innerHTML.replace(new RegExp(this.options.highlight, 'gi'), '<mark data-hr class="data-hr">' + this.options.replaceWith + '</mark>')
          }

          this.bcolor(this.el[i]);
      }

  }
}
