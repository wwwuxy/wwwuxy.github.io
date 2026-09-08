#!/usr/bin/env ruby
# Nokogiri is already part of the GitHub Pages bundle.
require 'bundler/setup'
require 'nokogiri'
require 'yaml'

failures = []
check = lambda do |condition, message|
  failures << message unless condition
end
pages = %w[index.html research/index.html projects/index.html notes/index.html]
documents = pages.to_h do |path|
  [path, Nokogiri::HTML(File.read(File.join('_site', path)))]
end
projects = YAML.load_file('_data/projects.yml')
home = documents.fetch('index.html')
project_page = documents.fetch('projects/index.html')

check.call(home.css('article.lw-project-card').length == 5, 'Home must render five reference-style project cards')
check.call(project_page.css('article.lw-project-card').length == projects.length,
           'Projects must render every configured repository as a reference-style card')

projects.each do |project|
  url = project.fetch('url')
  cards = project_page.css('article.lw-project-card').select do |card|
    card.at_css('h3 a')&.[]('href') == url
  end
  check.call(cards.length == 1, "Projects must render one card for #{project.fetch('slug')}")
  card = cards.first
  next unless card

  check.call(card.at_css('h3 a')&.text&.strip == project.fetch('name'),
             "#{project.fetch('slug')} must keep its configured name")
  if project['description']
    check.call(card.at_css('p')&.text&.strip == project['description'],
               "#{project.fetch('slug')} must render its supplied description")
  else
    check.call(card.at_css('p').nil?, "#{project.fetch('slug')} must not invent a description")
  end
  check.call(card.at_css('a.lw-mini-link')&.[]('href') == url,
             "#{project.fetch('slug')} must retain its GitHub card link")
end

projects.select { |project| project['featured'] }.each do |project|
  cards = home.css('article.lw-project-card').select do |card|
    card.at_css('h3 a')&.[]('href') == project['url']
  end
  check.call(cards.length == 1, "Home must render a linked card for #{project['slug']}")
end

documents.each do |path, document|
  check.call(document.css('pre code').none? { |node| node.text.include?('project-card') || node.text.include?('github.com/wwwuxy/') },
             "#{path} must not escape project markup into code blocks")
  menu = document.at_css('#site-nav > button')
  check.call(menu && menu['type'] == 'button' && !menu['aria-label'].to_s.strip.empty?,
             "#{path} navigation must have a named native button")
  check.call(menu && menu['aria-expanded'] == 'false' && document.at_css("ul##{menu['aria-controls']}")&.[]('class').to_s.split.include?('hidden'),
             "#{path} navigation must identify its initially collapsed menu")
  check.call(document.at_css('#theme-toggle').nil? && document.at_css('html')['data-theme'].nil?,
             "#{path} must use the site's light theme without an unused theme control")
  check.call(document.css('footer .page__footer-follow, footer .page__footer-copyright').empty?,
             "#{path} footer must not render removed follow or copyright content")
  check.call(document.css('a').any? { |link| link['href'] == 'https://github.com/wwwuxy' },
             "#{path} must have a working GitHub profile anchor")
end

Dir.glob('_site/**/*.html').each do |path|
  check.call(!Nokogiri::HTML(File.read(path)).text.match?(/diff\s+(?:--|–|—)git/), "#{path} must not publish patch text")
end
%w[docs scripts docker-compose.yaml].each do |path|
  check.call(!File.exist?(File.join('_site', path)), "#{path} must be excluded from publication")
end
check.call(Dir.glob('_site/**/*.gem').empty?, 'Local Ruby package archives must be excluded from publication')
check.call(File.file?('_site/sitemap.xml'), 'The sitemap destination must exist')
check.call(!File.exist?('.github/workflows/bad-pr.yml'), 'The upstream PR-closing workflow must be removed')
Dir.glob('.github/workflows/*.{yml,yaml}').each do |path|
  workflow = YAML.load_file(path)
  triggers = workflow['on'] || workflow[true] || {}
  check.call(!triggers.is_a?(Hash) || !triggers.key?('workflow_run'), "#{path} must not depend on the removed PR workflow")
end

abort failures.map { |failure| "FAIL: #{failure}" }.join("\n") unless failures.empty?
puts 'Rendered-site audit passed: reference-style project cards, controls, sitemap and publication exclusions.'
