# frozen_string_literal: true

# PORO to represent an artwork
class BaseThumbnailScraper
  attr_accessor :name, :extensions, :link, :image

  # @param [Nokogiri::XML::Element] element
  def self.parse(element)
    name = extract_name(element)
    link = extract_link(element)
    image = extract_image(element)
    extensions = extract_extensions(element)
    new(name:, extensions:, link:, image:)
  end

  def self.extract_name(element)
    raise NotImplementedError, "Implement extract_name class method"
  end

  def self.extract_link(element)
    raise NotImplementedError, "Implement extract_link class method"
  end

  def self.extract_extensions(element)
    raise NotImplementedError, "Implement extract_extensions class method"
  end

  # @param [Nokogiri::XML::Element] image_node
  def self.extract_image(element)
    raise NotImplementedError, "Implement extract_image class method"
  end

  def initialize(name:, extensions:, link:, image:)
    @name = name
    @extensions = extensions
    @link = link
    @image = image
  end

  def as_json
    {
      "name" => @name,
      "link" => @link,
      "image" => @image
    }.tap do |hash|
      hash["extensions"] = [@extensions] unless @extensions == ""
    end
  end
end
