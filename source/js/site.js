//= require jquery/dist/jquery.min
//= require foundation/js/foundation/foundation
//= require foundation/js/foundation/foundation.topbar

$(document).foundation();

/**
 * Adapted from cbpAnimatedHeader.js v1.0.0
 * Copyright 2013, Codrops - http://www.codrops.com - MIT licensed
 */
!function(navSelector, changeAt) {
  function onScroll() {
    $(navSelector)[$(window).scrollTop() >= changeAt ? 'addClass' : 'removeClass']('navbar-shrink');
  }
  window.addEventListener('scroll', onScroll, false);
}('header.global-nav', 50);

!function(offset) {
  function onScroll() {
    var yScroll = $(window).scrollTop() + offset;
    var currentEl = false;
    $('[data-nav-dest]').each(function(idx) {
      if (yScroll > $(this).offset().top) currentEl = this;
    });
    if (currentEl) {
      var dest = currentEl.getAttribute('data-nav-dest');
      $('[data-nav-href]').each(function(idx) {
        $(this)[this.getAttribute('data-nav-href') === dest ? 'addClass' : 'removeClass']('active');
      });
    }
    else {
      $('[data-nav-href]').removeClass('active');
    }
  }
  window.addEventListener('scroll', onScroll, false);
}(50);
