module XsltRender
  class Template
    def initialize(template)
      @template = template
    end

    def render(data, builder = :nokogiri)
      data = data.is_a?(String) ? data : data.to_xml
      case builder
        when :libxml then
          render_libxml(data)
        else
          render_nokogiri(data)
      end
    end

    private
    def render_nokogiri(data)
      xml = Nokogiri::XML(data)
      xslt = Nokogiri::XSLT(@template)
      xslt.transform(xml)
    end

    def render_libxml(data)
      xslt = XML::XSLT.new()
      xslt.xml = data
      xslt.xsl = @template
      xslt.serve()
    end
  end
end
