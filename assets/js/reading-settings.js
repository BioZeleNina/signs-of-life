// Signs of life -- reading settings toolbar
// Adds font (Sans/Serif) and theme (White/Sepia/Night) toggles

(function () {
  // ---- Build toolbar HTML ----
  var toolbar = document.createElement('div');
  toolbar.id = 'reading-toolbar';
  toolbar.innerHTML =
    '<div class="rt-group">' +
      '<span class="rt-label">Font</span>' +
      '<button class="rt-btn rt-font-btn" id="rt-sans">Sans</button>' +
      '<button class="rt-btn rt-font-btn" id="rt-serif">Serif</button>' +
    '</div>' +
    '<div class="rt-divider"></div>' +
    '<div class="rt-group">' +
      '<span class="rt-label">Theme</span>' +
      '<button class="rt-btn rt-theme-btn" id="rt-white">White</button>' +
      '<button class="rt-btn rt-theme-btn" id="rt-sepia">Sepia</button>' +
      '<button class="rt-btn rt-theme-btn" id="rt-night">Night</button>' +
    '</div>';

  // ---- Insert toolbar ----
  document.addEventListener('DOMContentLoaded', function () {
    var main = document.querySelector('.main-content');
    if (!main) { main = document.body; }
    main.insertBefore(toolbar, main.firstChild);

    // Load saved preferences (localStorage persists between sessions)
    var savedFont  = localStorage.getItem('sol-font')  || 'sans';
    var savedTheme = localStorage.getItem('sol-theme') || 'white';
    applyFont(savedFont);
    applyTheme(savedTheme);

    // Font buttons
    document.getElementById('rt-sans').addEventListener('click', function () {
      applyFont('sans');
      localStorage.setItem('sol-font', 'sans');
    });
    document.getElementById('rt-serif').addEventListener('click', function () {
      applyFont('serif');
      localStorage.setItem('sol-font', 'serif');
    });

    // Theme buttons
    document.getElementById('rt-white').addEventListener('click', function () {
      applyTheme('white');
      localStorage.setItem('sol-theme', 'white');
    });
    document.getElementById('rt-sepia').addEventListener('click', function () {
      applyTheme('sepia');
      localStorage.setItem('sol-theme', 'sepia');
    });
    document.getElementById('rt-night').addEventListener('click', function () {
      applyTheme('night');
      localStorage.setItem('sol-theme', 'night');
    });
  });

  // ---- Apply functions ----
  function applyFont(font) {
    document.body.classList.remove('sol-font-sans', 'sol-font-serif');
    document.body.classList.add('sol-font-' + font);
    document.querySelectorAll('.rt-font-btn').forEach(function (b) {
      b.classList.remove('rt-active');
    });
    var btn = document.getElementById('rt-' + font);
    if (btn) { btn.classList.add('rt-active'); }
  }

  function applyTheme(theme) {
    document.body.classList.remove('sol-white', 'sol-sepia', 'sol-night');
    document.body.classList.add('sol-' + theme);
    document.querySelectorAll('.rt-theme-btn').forEach(function (b) {
      b.classList.remove('rt-active');
    });
    var btn = document.getElementById('rt-' + theme);
    if (btn) { btn.classList.add('rt-active'); }
  }
})();
