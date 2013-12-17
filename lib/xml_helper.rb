require 'nokogiri'
require 'ostruct'

module XmlHelper
  module Array
    def to_xml(builder = :nokogiri)
      case builder
        when :libxml then
          xml = LibXML::XML::Document.new
          xml.encoding = LibXML::XML::Encoding::UTF_8
          xml.root = LibXML::XML::Node.new('items')
          self.each { |item| xml.root << xml.import(item.to_xml(:libxml, true)) }
          xml.to_s
        else
          builder = ::Nokogiri::XML::Builder.new { |xml| xml.items {} }
          self.each { |item| builder.doc.root.add_child(item.to_xml) }
          builder.to_xml
      end
    end
  end

  module OpenStruct
    # create xml with nokogiri
    def to_xml(builder = :nokogiri, source = false)
      case builder
        when :libxml then
          xml = LibXML::XML::Document.new
          xml.encoding = LibXML::XML::Encoding::UTF_8
          xml.root = build_node_libxml(@table, 'item')
          source ? xml.root : xml.root.to_s
        else
          builder = ::Nokogiri::XML::Builder.new() do |xml|
            xml.item do
              build_node_nokogiri(@table, xml)
            end
          end
          builder.doc.root
      end
    end

    private
    # create xml with nokogiri
    def build_node_nokogiri(nodes, xml)
      nodes.each do |node, val|
        if %w[String Fixnum Float Bignum NilClass].include?(val.class.name)
          xml.send(node, val)
        elsif val.is_a?(Hash)
          xml.send(node) do
            build_node_nokogiri(val, xml)
          end
        end
      end
    end

    def build_node_libxml(nodes, name)
      root = LibXML::XML::Node.new(name)
      nodes.each do |node, val|
        if %w[String Fixnum Float Bignum NilClass].include?(val.class.name)
          root << LibXML::XML::Node.new(node, val.to_s)
        elsif val.is_a?(Hash)
          root << build_node_libxml(val, node)
        end
      end
      root
    end
  end
end

class Array
  include XmlHelper::Array
end

class OpenStruct
  include XmlHelper::OpenStruct
end