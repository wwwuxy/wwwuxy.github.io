#!/usr/bin/env node
'use strict';

// A narrow runtime smoke check for site-owned JS. jQuery's browser implementation
// is supplied by the existing bundle; this fixture models only our DOM boundary.
const assert = require('assert');
const fs = require('fs');
const vm = require('vm');

function runSiteScript(source, filename, orientationSupported) {
  const elements = new Map();
  const window = {};
  const document = {};

  class Element {
    constructor(selector) {
      this.selector = selector;
      this.classes = new Set(selector.includes('hidden-links') ? ['hidden'] : []);
      this.attributes = {};
      this.styles = { display: selector === '.author__urls' ? 'none' : 'block' };
      this.handlers = {};
      this.length = 0;
    }
    on(event, handler) { (this.handlers[event] ||= []).push(handler); return this; }
    trigger(event, detail = {}) { (this.handlers[event] || []).forEach(handler => handler.call(this, detail)); return this; }
    ready(handler) { handler(); return this; }
    resize(handler) { return this.on('resize', handler); }
    children() { return new Element('children'); }
    width() { return this.selector === '#site-nav' ? 390 : 0; }
    height() { return 70; }
    outerHeight() { return 100; }
    is() { return true; }
    css(name, value) { if (value === undefined) return this.styles[name]; this.styles[name] = value; return this; }
    attr(name, value) { if (value === undefined) return this.attributes[name]; this.attributes[name] = String(value); return this; }
    hasClass(name) { return this.classes.has(name); }
    addClass(name) { this.classes.add(name); return this; }
    removeClass(name) { this.classes.delete(name); return this; }
    toggleClass(name) { this.classes.has(name) ? this.classes.delete(name) : this.classes.add(name); return this; }
    fadeToggle() { this.styles.display = this.styles.display === 'none' ? 'block' : 'none'; return this; }
    focus() { this.focused = true; return this; }
  }

  function $(selector) {
    if (selector instanceof Element) return selector;
    const key = selector === window ? 'window' : selector === document ? 'document' : selector;
    if (!elements.has(key)) elements.set(key, new Element(key));
    return elements.get(key);
  }
  const screen = orientationSupported ? { orientation: { addEventListener() {} } } : {};
  const context = { $, jQuery: $, window, document, screen, setInterval() {} };
  vm.runInNewContext(source, context, { filename });

  const follow = $('.author__urls-wrapper button');
  follow.trigger('click');
  assert.strictEqual($('.author__urls').css('display'), 'block', `${filename}: mobile Follow must open its links`);
  follow.trigger('click');
  assert.strictEqual($('.author__urls').css('display'), 'none', `${filename}: mobile Follow must close its links`);

  const menu = $('#site-nav button');
  const links = $('#site-nav .hidden-links');
  assert.strictEqual(menu.attr('aria-expanded'), 'false', `${filename}: menu must start collapsed`);
  menu.trigger('click');
  assert.strictEqual(links.hasClass('hidden'), false, `${filename}: menu activation must expose links`);
  assert.strictEqual(menu.attr('aria-expanded'), 'true', `${filename}: open menu must announce its state`);
  let prevented = false;
  $('#site-nav').trigger('keydown', { key: 'Escape', preventDefault() { prevented = true; } });
  assert.strictEqual(links.hasClass('hidden'), true, `${filename}: Escape must close the menu`);
  assert.strictEqual(menu.attr('aria-expanded'), 'false', `${filename}: Escape must reset expanded state`);
  assert.ok(menu.focused && prevented, `${filename}: Escape must restore focus to the control`);
  menu.trigger('click');
  $(window).trigger('resize');
  assert.strictEqual(menu.attr('aria-expanded'), 'false', `${filename}: a fully visible navigation must reset expanded state`);
}

const source = ['assets/js/plugins/jquery.greedy-navigation.js', 'assets/js/_main.js']
  .map(path => fs.readFileSync(path, 'utf8')).join('\n');
const bundlePath = 'assets/js/main.min.js';
const bundle = fs.readFileSync(bundlePath, 'utf8');
new vm.Script(bundle, { filename: bundlePath });
const applicationStart = bundle.search(/\bvar \$nav\s*=/);
assert.ok(applicationStart > 0, 'The served bundle must contain jQuery followed by the site navigation');
const application = bundle.slice(applicationStart);
// Run the served app first so a stale generated bundle cannot hide a failure.
for (const [name, code] of [[bundlePath, application], ['site JS sources', source]]) {
  for (const orientationSupported of [true, false]) runSiteScript(code, name, orientationSupported);
}
console.log('JS smoke check passed: source and served bundle parse; Follow and navigation work with and without screen.orientation; expanded state and Escape focus are synchronized.');
