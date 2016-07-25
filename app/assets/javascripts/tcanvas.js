(function(global, factory) {
  // AMD
  if (typeof define === 'function' && define.amd) {
    define(['jquery'], function(jQuery) {
      return factory(global, jQuery);
    });
    // CommonJS/Browserify
  } else if (typeof exports === 'object') {
    factory(global, require('jquery'));
    // Global
  } else {
    factory(global, global.jQuery);
  }
}(typeof window !== 'undefined' ? window : this, function(window, $) {
  'use strict';

  var $_canvas, $_context, $img;
  var $start_pos, $end_pos;
  var $is_down = false;

  Tcanvas.defaults = {
    // Should always be non-empty
    // Used to bind jQuery events without collisions
    // A guid is not added here as different instantiations/versions of panzoom
    // on the same element is not supported, so don't do it.
    eventNamespace: '.panzoom',

    // Whether or not to transition the scale
    transition: true,

    // Default cursor style for the element
    cursor: 'move',

    // There may be some use cases for zooming without panning or vice versa
    disablePan: false,
    disableZoom: false,

    // Pan only on the X or Y axes
    disableXAxis: false,
    disableYAxis: false,

    // Set whether you'd like to pan on left (1), middle (2), or right click (3)
    which: 1,

    // The increment at which to zoom
    // adds/subtracts to the scale each time zoomIn/Out is called
    increment: 0.3,

    // Turns on exponential zooming
    // If false, zooming will be incremented linearly
    exponential: true,

    // Pan only when the scale is greater than minScale
    panOnlyWhenZoomed: false,

    // min and max zoom scales
    minScale: 0.3,
    maxScale: 6,

    // The default step for the range input
    // Precendence: default < HTML attribute < option setting
    rangeStep: 0.05,

    // Animation duration (ms)
    duration: 200,
    // CSS easing used for scale transition
    easing: 'ease-in-out',

    // Indicate that the element should be contained within it's parent when panning
    // Note: this does not affect zooming outside of the parent
    // Set this value to 'invert' to only allow panning outside of the parent element (basically the opposite of the normal use of contain)
    // 'invert' is useful for a large panzoom element where you don't want to show anything behind it
    contain: false
  }

  Tcanvas.prototype = {
    constructor: Tcanvas,

    instance: function() {
      return this;
    },
    touchstart: function() {

    }
  };

  function Tcanvas(elem, options) {

    if (!(this instanceof Tcanvas)) {
      return new Tcanvas(elem, options);
    }

    // Sanity checks
    if (elem.nodeType !== 1) {
      $.error('Panzoom called on non-Element node');
    }
    if (!$.contains(document, elem)) {
      $.error('Panzoom element must be attached to the document');
    }

    var $_canvas = $(elem);
    console.log($_canvas);
    var $context = $(elem).getContext('2d');

    $target.on('touchstart', function(evt) {
      $is_down = true;
      $start_pos = windowToCanvas(this, evt.originalEvent.touches[0].clientX, evt.originalEvent.touches[0].clientY);
    });

    $target.on('touchend', function(evt) {
      $is_down = false;
    });

    $target.on('touchmove', function(evt) {
      if ($is_down) {
        $end_pos = windowToCanvas(canvas, evt.originalEvent.touches[0].clientX, evt.originalEvent.touches[0].clientY);
        var offset_x = $end_pos.x - $start_pos.x;
        var offset_y = $end_pos.y - $start_pos.y;
        $start_pos = $end_pos;
        imgX += offset_x;
        imgY += offset_y;
        // drawImage();
      }
    });

  }

  function loadImage() {
    $img = new Image();
    $img.onload = function() {
      imgIsLoaded = true;
      drawImage();
    }
    $img.src = "http://172.168.1.8:3000/images/radar/201607180039_121.33270876765943_31.09048504244029.png";
  }

  function drawImage() {
    context.clearRect(0, 0, canvas.width, canvas.height);
    context.drawImage(img, 0, 0, img.width, img.height, imgX, imgY, img.width * imgScale, img.height * imgScale);
  }

  function windowToCanvas(canvas, x, y) {
    var bbox = canvas.getBoundingClientRect();
    return {
      x: x - bbox.left - (bbox.width - canvas.width) / 2,
      y: y - bbox.top - (bbox.height - canvas.height) / 2
    };
  }

  /**
   * [tcanvas description]
   * @param  {[type]} options [description]
   * @return {[type]}         [description]
   */
  $.fn.tcanvas = function(options) {
    return this.each(function() {
      new Tcanvas(this, options);
    });

  };

  return Tcanvas;
}));
