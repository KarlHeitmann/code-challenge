# frozen_string_literal: true

# PORO to represent a VisualArtist
class GoogleThumbnailScraperV2 < GoogleThumbnailScraperV1
  def self.extract_name(element)
    element.css("div > div:nth-child(1)").text
  end

  def self.extract_image(element)
    element.css("img")[0].get_attribute("src")
  end
end
