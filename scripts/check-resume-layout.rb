#!/usr/bin/env ruby
# Verifies visitor-visible profile details and the compact AcademicPages layout.
require 'bundler/setup'
require 'nokogiri'

document = Nokogiri::HTML(File.read('_site/index.html'))
failures = []
check = ->(condition, message) { failures << message unless condition }

sidebar = document.at_css('.sidebar')
brand = document.at_css('#site-nav .visible-links .masthead__menu-item.persist a')
navigation = document.css('#site-nav .visible-links .masthead__menu-item:not(.persist) a').map { |link| link.text.strip }
content = document.at_css('.page__content')

check.call(!sidebar.nil?, 'Home must retain the reference-style left profile sidebar')
check.call(brand&.text&.strip == 'WUXINYU', 'Masthead brand must show WUXINYU')
check.call(sidebar&.at_css('.author__name')&.text&.strip == 'WUXINYU', 'Sidebar must show WUXINYU')
check.call(sidebar&.css('img').to_a.empty?, 'Sidebar must not render an unprovided profile image')
check.call(content&.at_css('.lw-title')&.text&.strip&.start_with?('WUXINYU'), 'Home hero must identify WUXINYU')
check.call(!content&.text&.include?('吴欣宇'), 'Home must not show Chinese name 吴欣宇')
check.call(navigation == ['Home', 'Research', 'Open Source', 'Notes', 'GitHub'], 'Navigation must expose only available pages and GitHub')
check.call(content&.at_css('.lw-hero') != nil, 'Home must have a lw-hero section')
check.call(document.css('a').none? { |link| %w[/publications/ /patents/ /cv/].include?(link['href']) }, 'Home must not link to hidden pages')
check.call(!File.exist?('_site/cv/index.html'), 'The removed CV page must not be published')

%w[research projects notes publications patents].each do |page|
  page_document = Nokogiri::HTML(File.read("_site/#{page}/index.html"))
  check.call(page_document.at_css('.lw-hero').nil?, "#{page} must not render the Home-only gradient hero")
  check.call(!page_document.at_css('.lw-page-header').nil?, "#{page} must render a plain page header")
end

# Also verify non-index pages show WUXINYU in sidebar
research_doc = Nokogiri::HTML(File.read('_site/research/index.html')) rescue nil
if research_doc
  research_sidebar_name = research_doc.at_css('.sidebar .author__name')&.text&.strip
  check.call(research_sidebar_name == 'WUXINYU', "Research sidebar must show WUXINYU, got '#{research_sidebar_name}'")
  check.call(!research_doc.at_css('.page__content')&.text&.include?('吴欣宇'), 'Research page must not show Chinese name 吴欣宇')
end

abort failures.map { |failure| "FAIL: #{failure}" }.join("\n") unless failures.empty?
puts 'Resume layout audit passed.'
