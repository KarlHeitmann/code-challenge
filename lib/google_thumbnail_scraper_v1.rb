# frozen_string_literal: true

# PORO to represent an artwork
class GoogleThumbnailScraperV1
  DOMAIN = "https://www.google.com"
  REGEX_CAPTURE_IMAGE_STRING = ->(image_id) { /\(function\(\){var s='([^']+)';var ii=\['#{image_id}'\];_setImagesSrc\(ii,s\);}/ } # rubocop:disable Layout/LineLength
  attr_accessor :name, :extensions, :link, :image

  def initialize(name:, extensions:, link:, image:)
    @name = name
    @extensions = extensions
    @link = link
    @image = image
  end

  # @param [Nokogiri::XML::Element] element
  def self.parse(element)
    name = extract_name(element)
    link = extract_link(element)
    image = extract_image(element)
    extensions = extract_extensions(element)
    new(name:, extensions:, link:, image:)
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

  def self.extract_name(element)
    element.get_attribute("aria-label")
  end

  def self.extract_link(element)
    DOMAIN + element.get_attribute("href")
  end

  def self.extract_extensions(element)
    element.css("div:nth-child(2) > div:nth-child(2)").text
  end

  # @param [Nokogiri::XML::Element] image_node
  def self.extract_image(element)
    image_node = element.css("div:nth-child(1) img")[0]
    image_id = image_node.get_attribute("id")
    match_data = image_node.document.to_s.match(
      REGEX_CAPTURE_IMAGE_STRING.call(image_id)
    )
    return nil unless match_data

    remove_wrong_escape_sequences(match_data)
  end

  def self.remove_wrong_escape_sequences(match_data)
    match_data.captures[0].gsub(/((\\x3d)+)$/) do |t|
      # \x3d+ => x3d+
      a = t.split("\\")
      a.shift
      a.join
    end
  end
end
