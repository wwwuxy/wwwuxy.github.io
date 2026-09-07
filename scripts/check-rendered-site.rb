#!/usr/bin/env ruby
# Nokogiri is already part of the GitHub Pages bundle.
require 'bundler/setup'
require 'nokogiri'
require 'yaml'

failures = []
check = lambda do |condition, message|
  failures << message unless condition
end
pages = %w[index.html research/index.html projects/index.html notes/index.html cv/index.html]
documents = pages.to_h do |path|
  [path, Nokogiri::HTML(File.read(File.join('_site', path)))]
end
projects = YAML.load_file('_data/projects.yml')
home = documents.fetch('index.html')
project_page = documents.fetch('projects/index.html')

check.call(home.css('article.project-card').length == 5, 'Home must render five project-card articles')
check.call(project_page.css('article.project-card').length == 6, 'Projects must render six project-card articles')

categories = {
  'Processor & Numerical Architecture' => %w[dfpvu qvu pvu],
  'AI Accelerator Software Stack' => %w[cvikernel cviruntime cnpy-for-tpu_mlir],
  'Other Open Source' => %w[cvibuilder rt-thread-am riscv-board-wandering]
}
categories.each do |category, slugs|
  heading = project_page.css('.page__content h2').find { |node| node.text.strip == category }
  check.call(!heading.nil?, "Missing Projects category heading: #{category}")
  slugs.each do |slug|
    project = projects.find { |entry| entry.fetch('slug') == slug }
    url = project.fetch('url')
    links = project_page.css('.page__content a').select { |link| link['href'] == url }
    check.call(links.length == 1, "Projects must have one rendered anchor to #{url}")
    links.each do |link|
      preceding_heading = link.xpath('preceding::h2').last
      check.call(preceding_heading && preceding_heading.text.strip == category,
                 "#{slug} must appear under #{category}")
      check.call(link['target'] == '_blank' && %w[noopener noreferrer].all? { |rel| link['rel'].to_s.split.include?(rel) },
                 "#{slug} must have safe external-link attributes")
      card = link.ancestors('article.project-card').first
      if project['description']
        check.call(card && card.at_css('.project-card__description')&.text&.strip == project['description'],
                   "#{slug} must render its supplied description inside a card")
      else
        check.call(card.nil? && link.parent.name == 'p' && link.text.strip == project['name'],
                   "#{slug} must render as a repository link without an invented card description")
      end
    end
  end
end

projects.select { |project| project['featured'] }.each do |project|
  cards = home.css('article.project-card').select do |card|
    card.at_css('a.project-card__link')&.[]('href') == project['url']
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
  check.call(document.css('footer a').any? { |link| link['href'] == '/sitemap.xml' },
             "#{path} footer must link to /sitemap.xml")
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
puts 'Rendered-site audit passed: five Home cards, six Projects cards, three sparse repository links, categories, controls, sitemap and publication exclusions.'
