Compare perfomance ruby template engine:
 * erubie (erb),
 * slim,
 * haml,
 * xml+xslt via Nokogiri gem
 * xml+xslt via libxml2 & libxslt

Notice:
  Benchmark 1 call render template every time.

  Benchmark 2 call pre render template.

  XSLT render includes: object -> xml conversation and XML+XSLT -> HTML transformation


For use:
  1.   git clone https://github.com/samid/templates_benchmark.git
  2.   vi .ruby-version && vi .ruby-gemset
  3.   bundle install
  4.   chmod +x benchmark_compare.rb
  5.   ./benchmark_compare.rb

Customize template:
  *   vi person.erb
  *   rm person.haml person.slim (auto generated from person.erb)
  *   vi person.xslt




