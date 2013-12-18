#!/usr/bin/env ruby
#
# Benchmark ruby template engine: ERB SLIM HAML XML_XSLT(nokogiri)
#
require 'rubygems'
require 'bundler/setup'
require 'xml'
require 'xml/xslt'

%w[erubis slim haml benchmark ruby-prof nokogiri terminal-table].each { |f| require f }
Dir['./lib/*.rb'].each { |f| require f }

# Testing
TOTAL_TEST = 10000
TOTAL_PERSON = TOTAL_TEST
templates = Template::prepare
xml_renders = [:nokogiri, :libxml]

# Fixtures
persons = (0...TOTAL_PERSON).map do |v|
  person = OpenStruct.new name_first: "Name#{('a'..'z').to_a.shuffle[0, 5].join}",
                          name_last: 'Last',
                          name_middle: 'Middle',
                          profile: {age: 21 + rand(10), gender: 'male', status: 'single'}

  person.define_singleton_method(:person) { self }
  person
end

persons.instance_eval do
  extend XmlHelper::Array
end

# Show render example
person_xml = {}
person_xml[:nokogiri] = persons[0, 1].to_xml
person_xml[:libxml] = persons[0, 1].to_xml(:libxml)
person = persons[rand(TOTAL_PERSON)]

render_output = {}
render_output[:erb] = Erubis::Eruby.new(templates[:erb]).result(person: person)
render_output[:haml] = Haml::Engine.new(templates[:haml]).render(person)
render_output[:slim] = Slim::Template.new(pretty: true) { templates[:slim] }.render(person)
render_output[:xslt] = XsltRender::Template.new(templates[:xslt]).render(person_xml[:nokogiri])
# render_output[:xml] = person_xml[:nokogiri] #generated XML

render_output.each do |engine, source|
  table = Terminal::Table.new title: engine.upcase,
                              headings: ['heml', 'source template'],
                              rows: [[source, templates[engine]]]
  puts "\nRender:\n #{table}"
end

# Benchmark
puts "\n\nBenchmark 1... Total objects: #{TOTAL_PERSON}. Total test pass: #{TOTAL_TEST} \n\n"
html = ''

Benchmark.bmbm (10) do |b|
  b.report(:erubis_render) do
    (0...TOTAL_TEST).each { |id| html = Erubis::Eruby.new(templates[:erb]).result(person: persons[id]) }
  end
  b.report(:haml_render) do
    (0...TOTAL_TEST).each { |id| html = Haml::Engine.new(templates[:haml]).render(persons[id]) }
  end
  b.report(:haml_ugly_render) do
    (0...TOTAL_TEST).each { |id| html = Haml::Engine.new(templates[:haml], ugly: true).render(persons[id]) }
  end
  b.report(:slim_render) do
    (0...TOTAL_TEST).each { |id| html = Slim::Template.new { templates[:slim] }.render(persons[id]) }
  end

  # include type for convert array with object to xml
  xml_renders.each do |type|
    b.report(type) do
      html = XsltRender::Template.new(templates[:xslt]).render(persons.to_xml(type), type)
    end
  end
end

puts "\n\nBenchmark 2... Total objects: #{TOTAL_PERSON}. Total test pass: #{TOTAL_TEST} \n\n"
html = ''
render = {}
render[:erubis] = Erubis::Eruby.new(templates[:erb])
render[:haml] = Haml::Engine.new(templates[:haml])
render[:haml_ugly] = Haml::Engine.new(templates[:haml], ugly: true)
render[:slim] = Slim::Template.new { templates[:slim] }

xml_renders.each do |type|
  render[type] = XsltRender::Template.new(templates[:xslt])
end

Benchmark.bmbm (10) do |b|
  b.report(:erubis_render) do
    (0...TOTAL_TEST).each { |id| html = render[:erubis].result(person: persons[id]) }
  end
  b.report(:haml_render) do
    (0...TOTAL_TEST).each { |id| html = render[:haml].render(persons[id]) }
  end
  b.report(:haml_ugly_render) do
    (0...TOTAL_TEST).each { |id| html = render[:haml_ugly].render(persons[id]) }
  end
  b.report(:slim_render) do
    (0...TOTAL_TEST).each { |id| html = render[:slim].render(persons[id]) }
  end

  # include type for convert array with object to xml
  xml_renders.each do |type|
    b.report(type) do
      html = render[type].render(persons.to_xml(type), type)
    end
  end
end

puts "\npress Enter to continue\n"
gets

puts "\nProfile erubis\n"
RubyProf.start
(0...TOTAL_TEST).each { |id| html = render[:erubis].result(person: persons[0]) }
result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)

puts "\nProfile haml\n"
RubyProf.start
(0...TOTAL_TEST).each { |id| html = render[:haml].render(persons[0]) }
result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)

puts "\nProfile slim\n"
RubyProf.start
(0...TOTAL_TEST).each { |id| html = render[:slim].render(persons[0]) }
result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)

puts "\nProfile xslt\n"
xml_renders.each do |type|
  RubyProf.start
  html = render[type].render(persons.to_xml(type), type)
  result = RubyProf.stop
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT)
end
