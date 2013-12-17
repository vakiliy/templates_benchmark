module Template
  require 'html2haml'
  require 'html2slim'

  TEMPLATE_NAME = File.join(File.dirname(File.expand_path(__FILE__)), '../templates/person')

  def self.engine
    Hash haml: Proc.new { |template| Haml::HTML.new(template, erb: true).render.to_s },
         slim: Proc.new { |template| HTML2Slim::ERBConverter.new(template).to_s },
         xslt: Proc.new { |template| raise "XSLT template #{template} not fount." }
  end

  def self.prepare
    templates = {}

    templates[:erb] = File.read("#{TEMPLATE_NAME}.erb")

    engine.keys.each do |type|
      file_name = "#{TEMPLATE_NAME}.#{type}"
      if File.exist?(file_name)
        templates[type] = File.read(file_name)
      else
        templates[type] = engine[type].call(templates[:erb])
        File.write(file_name, templates[type])
      end
    end
    templates
  end
end