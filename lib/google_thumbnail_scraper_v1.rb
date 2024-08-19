# frozen_string_literal: true

require_relative "base_thumbnail_scraper"

# PORO to represent an artwork
class GoogleThumbnailScraperV1 < BaseThumbnailScraper
  DOMAIN = "https://www.google.com"
  REGEX_CAPTURE_IMAGE_STRING = ->(image_id) { /\(function\(\){var s='([^']+)';var ii=\['#{image_id}'\];_setImagesSrc\(ii,s\);}/ } # rubocop:disable Layout/LineLength
  attr_accessor :name, :extensions, :link, :image

  # @param [Nokogiri::XML::Element] element
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
