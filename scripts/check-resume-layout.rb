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
check.call(brand&.text&.strip == '吴欣宇', 'Masthead brand must show 吴欣宇')
check.call(sidebar&.at_css('.author__name')&.text&.strip == '吴欣宇', 'Sidebar must show 吴欣宇')
check.call(sidebar&.css('img').to_a.empty?, 'Sidebar must not render an unprovided profile image')
check.call(content&.at_css('h1')&.text&.include?('吴欣宇'), 'Home heading must identify 吴欣宇')
check.call(content&.text&.include?('西南科技大学'), 'Home must show the verified university')
check.call(content&.text&.include?('软件工程硕士'), 'Home must show the verified master degree')
check.call(content&.text&.include?('工程造价学士'), 'Home must show the verified bachelor degree')
check.call(!content&.text&.include?('Selected Timeline'), 'Home must not show an unsupported timeline')
check.call(navigation == ['Home', 'Research', 'Open Source', 'Notes', 'GitHub'], 'Navigation must expose only available pages and GitHub')
check.call(document.css('a').none? { |link| %w[/publications/ /patents/ /cv/].include?(link['href']) }, 'Home must not link to hidden pages')
check.call(!File.exist?('_site/cv/index.html'), 'The removed CV page must not be published')

abort failures.map { |failure| "FAIL: #{failure}" }.join("\n") unless failures.empty?
puts 'Resume layout audit passed.'
