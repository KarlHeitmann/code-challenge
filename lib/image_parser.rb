# frozen_string_literal: true

require "nokogiri"
require_relative "google_thumbnail_scraper_v1"

# Main class to parse images on a google search
class ImageParser
  attr_accessor :html_string

  def initialize(html_string:)
    @nokodoc = Nokogiri.HTML5(html_string)
  end

  def parse
    artworks = []
    carousels.each do |carousel|
      cards = carousel.css("a")
      artworks << cards.map { GoogleThumbnailScraperV1.parse(_1).as_json }
    end
    { "artworks" => artworks.flatten }
  end

  private

  def carousels
    @carousels ||= @nokodoc.css("g-scrolling-carousel").select do |carousel|
      carousel.attributes.keys.sort == %w[class data-hveid data-ved id jsaction jscontroller jsdata jsshadow style]
    end
  end
end
