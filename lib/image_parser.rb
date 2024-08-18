# frozen_string_literal: true

require "nokogiri"
require_relative "google_thumbnail_scraper_v1"
require_relative "google_thumbnail_scraper_v2"

# Main class to parse images on a google search
class ImageParser
  attr_accessor :html_string

  def initialize(html_string:)
    @nokodoc = Nokogiri.HTML5(html_string)
  end

  def parse
    artworks = []
    collections.each do |collection_meta|
      collection = collection_meta[:collection]
      query_element = collection_meta[:query_element]
      klass = collection_meta[:klass]
      cards = collection.css(query_element)
      artworks << cards.map { klass.parse(_1).as_json }
    end
    { "artworks" => artworks.flatten }
  end

  private

  def collections
    @collections ||= set_collections
  end

  def set_collections
    temp = attempt_g_scrolling_carousel
    return temp unless temp.empty?

    attempt_visual_artist_works
  end

  def attempt_g_scrolling_carousel
    @nokodoc
      .css("g-scrolling-carousel")
      .select { |carousel| carousel.attributes.keys.sort == %w[class data-hveid data-ved id jsaction jscontroller jsdata jsshadow style] } # rubocop:disable Layout/LineLength
      .map { |carousel| { collection: carousel, klass: GoogleThumbnailScraperV1, query_element: "a" } }
  end

  def attempt_visual_artist_works
    @nokodoc
      .css('div[data-attrid="kc:/visual_art/visual_artist:works"]')
      .map { |carousel| { collection: carousel, klass: GoogleThumbnailScraperV2, query_element: "a" } }
  end
end
