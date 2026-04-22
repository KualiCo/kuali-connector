/* Kuali three-state theme toggle: system | light | dark.
 *
 * - Replaces Material's built-in palette toggle (which is only two-state).
 * - Preference lives in localStorage under "kuali-theme".
 * - "system" mode follows prefers-color-scheme and reacts live to OS changes.
 * - Works with Material's instant navigation (re-binds on each page load). */

(function () {
  var STORAGE_KEY = "kuali-theme";
  var MODES = ["system", "light", "dark"];
  var mq = window.matchMedia("(prefers-color-scheme: dark)");

  function currentPref() {
    var v = localStorage.getItem(STORAGE_KEY);
    return MODES.indexOf(v) === -1 ? "system" : v;
  }

  function resolveScheme(pref) {
    if (pref === "system") return mq.matches ? "dark" : "light";
    return pref;
  }

  function applyScheme(scheme) {
    var md = scheme === "dark" ? "slate" : "default";
    document.documentElement.setAttribute("data-md-color-scheme", md);
    document.body.setAttribute("data-md-color-scheme", md);
    try {
      localStorage.setItem("__palette", JSON.stringify({
        index: scheme === "dark" ? 1 : 0,
        color: { scheme: md, primary: "custom", accent: "custom" }
      }));
    } catch (e) { /* ignore */ }
  }

  function setPref(pref) {
    try { localStorage.setItem(STORAGE_KEY, pref); } catch (e) { /* ignore */ }
    applyScheme(resolveScheme(pref));
    syncToggle();
  }

  function syncToggle() {
    var pref = currentPref();
    var buttons = document.querySelectorAll(".kuali-theme-toggle__btn");
    buttons.forEach(function (btn) {
      var active = btn.dataset.mode === pref;
      btn.setAttribute("aria-pressed", active ? "true" : "false");
      btn.classList.toggle("is-active", active);
    });
  }

  function renderToggle() {
    /* Header is persistent under instant nav, so skip re-render if already
     * mounted — just sync the active state. */
    if (document.querySelector(".kuali-theme-toggle")) {
      syncToggle();
      return;
    }

    var headerOptions = document.querySelector(".md-header__option");
    var header = document.querySelector(".md-header__inner");
    var host = headerOptions || header;
    if (!host) return;

    var wrap = document.createElement("div");
    wrap.className = "kuali-theme-toggle";
    wrap.setAttribute("role", "group");
    wrap.setAttribute("aria-label", "Color theme");

    var labels = {
      system: { label: "System", icon: "◐" },
      light: { label: "Light", icon: "☀" },
      dark: { label: "Dark", icon: "☾" }
    };

    MODES.forEach(function (mode) {
      var btn = document.createElement("button");
      btn.type = "button";
      btn.className = "kuali-theme-toggle__btn";
      btn.dataset.mode = mode;
      btn.setAttribute("aria-label", "Use " + labels[mode].label.toLowerCase() + " theme");
      btn.setAttribute("title", labels[mode].label + " theme");
      btn.innerHTML =
        '<span class="kuali-theme-toggle__icon" aria-hidden="true">' + labels[mode].icon + "</span>" +
        '<span class="kuali-theme-toggle__label">' + labels[mode].label + "</span>";
      btn.addEventListener("click", function () { setPref(mode); });
      wrap.appendChild(btn);
    });

    if (headerOptions) {
      headerOptions.parentNode.insertBefore(wrap, headerOptions);
    } else {
      host.appendChild(wrap);
    }

    syncToggle();
  }

  function handleSystemChange() {
    if (currentPref() === "system") {
      applyScheme(resolveScheme("system"));
    }
  }

  /* matchMedia change listener (once per page load is fine — the MQ object
   * is shared and survives instant-nav). */
  if (mq.addEventListener) {
    mq.addEventListener("change", handleSystemChange);
  } else if (mq.addListener) {
    mq.addListener(handleSystemChange);
  }

  function init() {
    applyScheme(resolveScheme(currentPref()));
    renderToggle();
  }

  /* Material exposes document$ as an Observable when instant nav is on.
   * Subscribe so we re-render on every page change. */
  if (typeof document$ !== "undefined" && document$.subscribe) {
    document$.subscribe(function () { init(); });
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
