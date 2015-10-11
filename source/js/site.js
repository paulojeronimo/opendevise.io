//= require jquery/dist/jquery.min
//= require foundation/js/foundation/foundation
//= require foundation/js/foundation/foundation.topbar

$(document).foundation();

/**
 * Adapted from cbpAnimatedHeader.js v1.0.0
 * Copyright 2013, Codrops - http://www.codrops.com - MIT licensed
 */
(function() {
  var navbar = document.querySelector('.global-nav'), changeAt = 50;

  function init() {
    window.addEventListener('scroll', scrollPage, false);
  }

  function scrollPage() {
    if (scrollY() >= changeAt) {
      if (!navbar.classList.contains('navbar-shrink')) {
        navbar.classList.add('navbar-shrink');
      }
    }
    else {
      navbar.classList.remove('navbar-shrink');
    }
  }

  function scrollY() {
    return window.pageYOffset || document.documentElement.scrollTop;
  }

  init();
})();

function activateNavItem(e) {
  var yScroll = window.pageYOffset + 50;
  var currentEl = null;
  $('[data-nav-dest]').each(function(idx, el) {
    if (yScroll > $(el).offset().top) {
      currentEl = el;
    }
  });
  if (currentEl) {
    $('[data-nav-href]').each(function(idx, el) {
      if (currentEl.getAttribute('data-nav-dest') === el.getAttribute('data-nav-href')) {
        if (!el.classList.contains('active')) el.classList.add('active');
      }
      else {
        el.classList.remove('active');
      }
    });
  }
  else {
    $('[data-nav-href]').each(function(idx, el) {
      el.classList.remove('active');
    });
  }
}

window.addEventListener('scroll', activateNavItem);
