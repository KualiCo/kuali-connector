/* Kuali three-state theme toggle: system | light | dark.
 *
 * - Replaces Material's built-in palette toggle (which is only two-state).
 * - Preference lives in localStorage under "kuali-theme". Default is "system".
 * - "system" mode follows prefers-color-scheme and reacts live to OS changes.
 * - UI is a single header icon button that opens a small menu on click.
 * - Works with Material's instant navigation (re-binds on each page load). */

(function () {
  var STORAGE_KEY = "kuali-theme";
  var MODES = ["system", "light", "dark"];
  var LABELS = {
    system: { label: "System", glyph: "◐" },
    light: { label: "Light", glyph: "☀" },
    dark: { label: "Dark", glyph: "☾" }
  };
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
    syncUi();
  }

  function syncUi() {
    var pref = currentPref();
    var trigger = document.querySelector(".kuali-theme-toggle__trigger");
    if (trigger) {
      trigger.setAttribute("aria-label", "Theme (currently " + LABELS[pref].label + "). Open theme menu.");
      trigger.setAttribute("title", "Theme: " + LABELS[pref].label);
      var glyph = trigger.querySelector(".kuali-theme-toggle__glyph");
      if (glyph) glyph.textContent = LABELS[pref].glyph;
    }
    /* Roving tabindex: only the active item is in the tab order; arrow keys
     * move focus inside the open menu. */
    document.querySelectorAll(".kuali-theme-toggle__item").forEach(function (btn) {
      var active = btn.dataset.mode === pref;
      btn.setAttribute("aria-checked", active ? "true" : "false");
      btn.setAttribute("tabindex", active ? "0" : "-1");
      btn.classList.toggle("is-active", active);
    });
  }

  function focusItem(wrap, index) {
    var items = Array.from(wrap.querySelectorAll(".kuali-theme-toggle__item"));
    if (!items.length) return;
    var clamped = ((index % items.length) + items.length) % items.length;
    items.forEach(function (item, i) {
      item.setAttribute("tabindex", i === clamped ? "0" : "-1");
    });
    items[clamped].focus();
  }

  function openMenu(wrap, opts) {
    wrap.classList.add("is-open");
    var trigger = wrap.querySelector(".kuali-theme-toggle__trigger");
    trigger.setAttribute("aria-expanded", "true");
    var items = Array.from(wrap.querySelectorAll(".kuali-theme-toggle__item"));
    var start = 0;
    if (opts && opts.focus === "last") {
      start = items.length - 1;
    } else if (opts && opts.focus === "first") {
      start = 0;
    } else {
      /* Default: focus the currently-selected item. */
      var active = wrap.querySelector(".kuali-theme-toggle__item.is-active");
      start = active ? items.indexOf(active) : 0;
    }
    focusItem(wrap, start);
  }

  function closeMenu(wrap, opts) {
    wrap.classList.remove("is-open");
    var trigger = wrap.querySelector(".kuali-theme-toggle__trigger");
    trigger.setAttribute("aria-expanded", "false");
    if (opts && opts.focusTrigger) trigger.focus();
  }

  function toggleMenu(wrap) {
    if (wrap.classList.contains("is-open")) closeMenu(wrap, { focusTrigger: true });
    else openMenu(wrap);
  }

  function handleDocumentClick(e) {
    document.querySelectorAll(".kuali-theme-toggle.is-open").forEach(function (wrap) {
      if (!wrap.contains(e.target)) closeMenu(wrap);
    });
  }

  function handleTriggerKeydown(e) {
    var wrap = e.currentTarget.closest(".kuali-theme-toggle");
    if (!wrap) return;
    if (e.key === "ArrowDown") {
      e.preventDefault();
      openMenu(wrap, { focus: "first" });
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      openMenu(wrap, { focus: "last" });
    }
  }

  function handleKeydown(e) {
    var wrap = document.querySelector(".kuali-theme-toggle.is-open");
    if (!wrap) return;
    var items = Array.from(wrap.querySelectorAll(".kuali-theme-toggle__item"));
    var i = items.indexOf(document.activeElement);
    if (e.key === "Escape") {
      e.preventDefault();
      closeMenu(wrap, { focusTrigger: true });
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      focusItem(wrap, i + 1);
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      focusItem(wrap, i - 1);
    } else if (e.key === "Home") {
      e.preventDefault();
      focusItem(wrap, 0);
    } else if (e.key === "End") {
      e.preventDefault();
      focusItem(wrap, items.length - 1);
    } else if (e.key === "Tab") {
      /* Tabbing out closes the menu without preventing the default nav. */
      closeMenu(wrap);
    }
  }

  function handleFocusOut(e) {
    var wrap = e.currentTarget;
    /* queueMicrotask so the incoming focus target is known. */
    queueMicrotask(function () {
      if (!wrap.contains(document.activeElement)) {
        closeMenu(wrap);
      }
    });
  }

  function renderToggle() {
    /* Header is persistent under instant nav, so skip re-render if already
     * mounted — just refresh the active state. */
    if (document.querySelector(".kuali-theme-toggle")) {
      syncUi();
      return;
    }

    var headerOptions = document.querySelector(".md-header__option");
    var header = document.querySelector(".md-header__inner");
    var host = headerOptions || header;
    if (!host) return;

    var wrap = document.createElement("div");
    wrap.className = "kuali-theme-toggle";
    wrap.addEventListener("focusout", handleFocusOut);

    var menuId = "kuali-theme-menu";

    var trigger = document.createElement("button");
    trigger.type = "button";
    trigger.className = "kuali-theme-toggle__trigger md-header__button md-icon";
    trigger.setAttribute("aria-haspopup", "menu");
    trigger.setAttribute("aria-expanded", "false");
    trigger.setAttribute("aria-controls", menuId);
    trigger.innerHTML = '<span class="kuali-theme-toggle__glyph" aria-hidden="true">◐</span>';
    trigger.addEventListener("click", function (e) {
      e.stopPropagation();
      toggleMenu(wrap);
    });
    trigger.addEventListener("keydown", handleTriggerKeydown);

    var menu = document.createElement("div");
    menu.className = "kuali-theme-toggle__menu";
    menu.id = menuId;
    menu.setAttribute("role", "menu");
    menu.setAttribute("aria-label", "Theme");

    MODES.forEach(function (mode) {
      var item = document.createElement("button");
      item.type = "button";
      item.className = "kuali-theme-toggle__item";
      item.dataset.mode = mode;
      item.setAttribute("role", "menuitemradio");
      item.setAttribute("aria-checked", "false");
      item.setAttribute("tabindex", "-1");
      item.innerHTML =
        '<span class="kuali-theme-toggle__item-glyph" aria-hidden="true">' + LABELS[mode].glyph + '</span>' +
        '<span class="kuali-theme-toggle__item-label">' + LABELS[mode].label + '</span>' +
        '<span class="kuali-theme-toggle__item-check" aria-hidden="true">✓</span>';
      item.addEventListener("click", function () {
        setPref(mode);
        closeMenu(wrap, { focusTrigger: true });
      });
      menu.appendChild(item);
    });

    wrap.appendChild(trigger);
    wrap.appendChild(menu);

    if (headerOptions) {
      headerOptions.parentNode.insertBefore(wrap, headerOptions);
    } else {
      host.appendChild(wrap);
    }

    syncUi();
  }

  function handleSystemChange() {
    if (currentPref() === "system") {
      applyScheme(resolveScheme("system"));
    }
  }

  /* One-time listeners — the matchMedia object and document survive
   * Material's instant navigation. */
  if (mq.addEventListener) mq.addEventListener("change", handleSystemChange);
  else if (mq.addListener) mq.addListener(handleSystemChange);
  document.addEventListener("click", handleDocumentClick);
  document.addEventListener("keydown", handleKeydown);

  function init() {
    applyScheme(resolveScheme(currentPref()));
    renderToggle();
  }

  if (typeof document$ !== "undefined" && document$.subscribe) {
    document$.subscribe(function () { init(); });
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
