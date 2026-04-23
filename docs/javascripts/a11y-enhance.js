/* Runtime accessibility enhancements.
 *
 * Material ships several icon-only / decorative patterns that lack proper
 * ARIA names. Rather than forking Material's partials and freezing us on a
 * specific upstream, we annotate them on the client. This file runs on every
 * page load (including instant-nav transitions) and is idempotent: each
 * enhancement marks its target so it isn't re-applied. */

(function () {
  "use strict";

  var FLAG = "data-kuali-a11y";

  function enhance(el, key, fn) {
    if (!el) return;
    var stamp = el.getAttribute(FLAG) || "";
    if (stamp.indexOf("|" + key + "|") !== -1) return;
    fn(el);
    el.setAttribute(FLAG, stamp + "|" + key + "|");
  }

  /* ---- Header / search ---------------------------------------------------- */

  function enhanceHeaderLabels() {
    document.querySelectorAll('label[for="__drawer"]').forEach(function (el) {
      enhance(el, "drawer-label", function (node) {
        if (!node.getAttribute("aria-label")) {
          node.setAttribute("aria-label", "Open navigation menu");
        }
      });
    });

    document.querySelectorAll('label[for="__search"]').forEach(function (el) {
      enhance(el, "search-label", function (node) {
        if (!node.getAttribute("aria-label")) {
          node.setAttribute("aria-label", "Open search");
        }
      });
    });

    var dialog = document.querySelector('.md-search[role="dialog"]');
    enhance(dialog, "search-dialog", function (node) {
      if (!node.getAttribute("aria-label")) {
        node.setAttribute("aria-label", "Search documentation");
      }
    });
  }

  /* ---- Edit-this-page icon link ------------------------------------------ */

  function enhanceEditLink() {
    document.querySelectorAll('a.md-content__button[rel="edit"]').forEach(function (el) {
      enhance(el, "edit-link", function (node) {
        if (!node.getAttribute("aria-label")) {
          node.setAttribute("aria-label", "Edit this page on GitHub");
        }
      });
    });
  }

  /* ---- Footer social icons ----------------------------------------------- */

  function enhanceSocialLinks() {
    document.querySelectorAll(".md-social__link").forEach(function (el) {
      enhance(el, "social-link", function (node) {
        if (node.getAttribute("aria-label")) return;
        var label = node.getAttribute("title") || "";
        try {
          var url = new URL(node.href);
          if (url.hostname) label = label || url.hostname;
        } catch (e) { /* ignore */ }
        if (!label) label = "External link";
        if (node.target === "_blank") label += " (opens in new tab)";
        node.setAttribute("aria-label", label);
      });
    });
  }

  /* ---- Heading permalinks ------------------------------------------------- */

  function enhancePermalinks() {
    document.querySelectorAll(".md-typeset .headerlink").forEach(function (el) {
      enhance(el, "permalink", function (node) {
        if (node.getAttribute("aria-label")) return;
        var heading = node.parentElement;
        var headingText = "";
        if (heading) {
          /* Clone so we can safely strip the pilcrow before reading text. */
          var clone = heading.cloneNode(true);
          var pilcrow = clone.querySelector(".headerlink");
          if (pilcrow) pilcrow.remove();
          headingText = clone.textContent.trim().replace(/\s+/g, " ");
        }
        node.setAttribute(
          "aria-label",
          headingText ? "Permalink to “" + headingText + "”" : "Permalink to this section"
        );
        /* Hide the pilcrow glyph from AT so the label isn't repeated. */
        if (node.childNodes.length === 1 && node.firstChild.nodeType === Node.TEXT_NODE) {
          var glyph = node.firstChild.nodeValue;
          node.textContent = "";
          var span = document.createElement("span");
          span.setAttribute("aria-hidden", "true");
          span.textContent = glyph;
          node.appendChild(span);
        }
      });
    });
  }

  /* ---- Clipboard toast + progress bar ------------------------------------ */

  function enhanceStatusWidgets() {
    document.querySelectorAll(".md-dialog__inner").forEach(function (el) {
      enhance(el, "toast-live", function (node) {
        if (!node.getAttribute("role")) node.setAttribute("role", "status");
        if (!node.getAttribute("aria-live")) node.setAttribute("aria-live", "polite");
      });
    });

    document.querySelectorAll('[data-md-component="progress"]').forEach(function (el) {
      enhance(el, "progress-label", function (node) {
        if (!node.getAttribute("aria-label")) node.setAttribute("aria-label", "Loading page");
      });
    });
  }

  /* ---- Decorative Twemoji SVGs ------------------------------------------- */
  /* When an inline Material/Twemoji icon sits next to visible label text we
   * want screen readers to skip the SVG so the name isn't read twice. */

  function enhanceDecorativeIcons() {
    document.querySelectorAll(".twemoji > svg, .md-icon > svg").forEach(function (svg) {
      enhance(svg, "decorative-svg", function (node) {
        if (node.getAttribute("aria-label")) return;
        if (node.querySelector("title")) return;
        if (node.getAttribute("aria-hidden") === "true") return;
        node.setAttribute("aria-hidden", "true");
        node.setAttribute("focusable", "false");
      });
    });
  }

  /* ---- Admonition title semantics ---------------------------------------- */
  /* The `admonition` extension renders titles as <p class="admonition-title">.
   * Promote them to role=heading with aria-level=3 and mark the container
   * role=note so screen-reader users can navigate by heading. */

  function enhanceAdmonitions() {
    document.querySelectorAll(".md-typeset .admonition").forEach(function (el) {
      enhance(el, "admonition-role", function (node) {
        var type = null;
        node.classList.forEach(function (c) {
          if (c === "admonition") return;
          if (!type) type = c;
        });
        /* Danger/failure/bug/error read like alerts; the rest are notes. */
        var isAlert = /^(danger|failure|bug|error)$/i.test(type || "");
        if (!node.getAttribute("role")) {
          node.setAttribute("role", isAlert ? "note" : "note");
        }
        var title = node.querySelector(".admonition-title");
        if (title && !title.hasAttribute("role")) {
          title.setAttribute("role", "heading");
          title.setAttribute("aria-level", "3");
        }
      });
    });

    /* Same treatment for pymdownx.details collapsibles (<details class="note">). */
    document.querySelectorAll(".md-typeset details.note, .md-typeset details.tip, .md-typeset details.info, .md-typeset details.warning, .md-typeset details.danger, .md-typeset details.example, .md-typeset details.quote, .md-typeset details.abstract").forEach(function (el) {
      enhance(el, "details-role", function (node) {
        var summary = node.querySelector("summary");
        if (summary && !summary.hasAttribute("aria-level")) {
          summary.setAttribute("aria-level", "3");
        }
      });
    });
  }

  /* ---- Tabbed content ARIA ----------------------------------------------- */
  /* pymdownx.tabbed renders as hidden radios + labels with no tab semantics.
   * Wrap each set in a tablist, label->tab, content->tabpanel, with
   * Left/Right/Home/End keyboard navigation per the ARIA APG tabs pattern. */

  function enhanceTabbedSets() {
    document.querySelectorAll(".tabbed-set").forEach(function (set) {
      enhance(set, "tabbed-aria", function (node) {
        var labels = Array.prototype.slice.call(node.querySelectorAll(":scope > .tabbed-labels > label, :scope > label"));
        var contents = Array.prototype.slice.call(node.querySelectorAll(":scope > .tabbed-content"));

        /* alternate_style renders <div class="tabbed-labels"> with the <label>
         * elements inside. Legacy style renders <label> siblings of content
         * panels. Normalize: look for a wrapper; if missing, leave the labels
         * where they are but still add the roles. */
        var list = node.querySelector(":scope > .tabbed-labels");
        if (list) list.setAttribute("role", "tablist");

        labels.forEach(function (label, i) {
          label.setAttribute("role", "tab");
          /* Focusable: only the selected tab is in the tab order. */
          var input = node.querySelector('input[id="' + label.getAttribute("for") + '"]');
          var selected = !!(input && input.checked);
          label.setAttribute("aria-selected", selected ? "true" : "false");
          label.setAttribute("tabindex", selected ? "0" : "-1");
          /* Associate the tab with its panel. */
          var panelId = label.getAttribute("for") + "--panel";
          label.setAttribute("aria-controls", panelId);
          if (contents[i]) {
            contents[i].setAttribute("role", "tabpanel");
            contents[i].setAttribute("aria-labelledby", label.getAttribute("for"));
            contents[i].id = panelId;
            /* Make the panel focusable so keyboard users can scroll it. */
            if (!contents[i].hasAttribute("tabindex")) {
              contents[i].setAttribute("tabindex", "0");
            }
          }

          label.addEventListener("keydown", function (e) {
            var targetIndex = null;
            if (e.key === "ArrowRight") targetIndex = (i + 1) % labels.length;
            else if (e.key === "ArrowLeft") targetIndex = (i - 1 + labels.length) % labels.length;
            else if (e.key === "Home") targetIndex = 0;
            else if (e.key === "End") targetIndex = labels.length - 1;
            if (targetIndex === null) return;
            e.preventDefault();
            labels[targetIndex].click();
            labels[targetIndex].focus();
          });
        });

        /* Listen for radio change to keep aria-selected accurate. */
        node.addEventListener("change", function () {
          labels.forEach(function (label) {
            var input = node.querySelector('input[id="' + label.getAttribute("for") + '"]');
            var selected = !!(input && input.checked);
            label.setAttribute("aria-selected", selected ? "true" : "false");
            label.setAttribute("tabindex", selected ? "0" : "-1");
          });
        });
      });
    });
  }

  /* ---- Entry point ------------------------------------------------------- */

  function run() {
    enhanceHeaderLabels();
    enhanceEditLink();
    enhanceSocialLinks();
    enhancePermalinks();
    enhanceStatusWidgets();
    enhanceDecorativeIcons();
    enhanceAdmonitions();
    enhanceTabbedSets();
  }

  if (typeof document$ !== "undefined" && document$.subscribe) {
    document$.subscribe(run);
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();
