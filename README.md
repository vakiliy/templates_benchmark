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
  1.   git clone https://github.com/vakiliy/templates_benchmark.git
  2.   vim .ruby-version && vim .ruby-gemset
  3.   bundle install
  4.   sh benchmark.rb

Customize template:
  *   vim person.erb
  *   rm person.haml person.slim (auto generated from person.erb)
  *   vim person.xslt

License: http://vakiliy.mit-license.org/

