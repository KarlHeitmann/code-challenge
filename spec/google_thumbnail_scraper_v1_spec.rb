# frozen_string_literal: true

describe GoogleThumbnailScraperV1 do
  describe "Unit tests" do
    # rubocop:disable Layout/LineLength
    describe "#extract_image" do
      let(:html_node_string) { <<-HTML_NODE }
        <img data-key="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQq3gOqqnprlNb3SdEgrKAR_0sWrsu0kO0aNnwE3yRwmA_cf-PvBvdz4eInim3FDmRn7E0" id="#{image_id}" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1" class="rISBZc M4dUYb" height="120" width="120" alt="">
      HTML_NODE
      let(:img_html_node) { Nokogiri.parse(html_node_string).css("img")[0] }
      let(:js_snippet) { "(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkjdLAhNsGUDAcqDkUqVKspsbgj//2Q\\x3d\\x3d';var ii=['#{image_id}'];_setImagesSrc(ii,s);}" }
      let(:image_id) { "kximg0" }
      before :each do
        allow(img_html_node).to receive_message_chain(:css, :[], :document, :to_s).and_return(js_snippet)
        allow(img_html_node).to receive_message_chain(:css, :[], :get_attribute).and_return(image_id)
      end
      it "extracts image base 64 string representation of given img node" do
        expect(GoogleThumbnailScraperV1.extract_image(img_html_node)).to eq("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkjdLAhNsGUDAcqDkUqVKspsbgj//2Qx3dx3d")
      end
    end

    describe "#remove_wrong_escape_sequences" do
      let(:base64_string) { "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkjdLAhNsGUDAcqDkUqVKspsbgj//2Q\\x3d\\x3d" }
      let(:image_id) { "kximg0" }
      let(:regex) { GoogleThumbnailScraperV1::REGEX_CAPTURE_IMAGE_STRING.call(image_id) }

      let(:match_data) { "(function(){var s='#{base64_embedded}';var ii=['kximg0'];_setImagesSrc(ii,s);}".match(regex) }
      context "when base64 string that contains \\ chars is passed as argument" do
        let(:base64_embedded) { "data:image/jpeg;base64,/9j/4AAQSkZJRgA/2wCEj//2Q\\x3d\\x3d" }
        let(:base64_expected) { "data:image/jpeg;base64,/9j/4AAQSkZJRgA/2wCEj//2Qx3dx3d" }

        it "removes \\ chars from base64 string" do
          expect(GoogleThumbnailScraperV1.remove_wrong_escape_sequences(match_data)).to eq(base64_expected)
        end
      end

      context "when base64 string without \\ chars is passed as argument" do
        let(:base64_embedded) { "data:image/jpeg;base64,/9j/4AAQSkZJRgA/2wCEj//2Qx3dx3d" }
        let(:base64_expected) { "data:image/jpeg;base64,/9j/4AAQSkZJRgA/2wCEj//2Qx3dx3d" }

        it "leaves the string as it is" do
          expect(GoogleThumbnailScraperV1.remove_wrong_escape_sequences(match_data)).to eq(base64_expected)
        end
      end
    end
    # rubocop:enable Layout/LineLength
  end

  describe "end to end tests" do
    let(:the_starry_night_base64_thumbnail) { File.read("spec/fixtures/the_starry_night_base64_thumbnail.txt") }
    let(:expected_the_starry_night_base64_thumbnail) { File.read("spec/fixtures/expected_the_starry_night_base64_thumbnail.txt") } # rubocop:disable Layout/LineLength
    let(:html_node_string) { <<-HTML_NODE }
      <html>
        <script>
          (function(){var s='#{the_starry_night_base64_thumbnail}';var ii=['kximg0'];_setImagesSrc(ii,s);})();
        </script>
        <a class="klitem" aria-label="The Starry Night" aria-posinset="1" aria-setsize="51" data-sp="0,17,26" href="/search?gl=us&amp;hl=en&amp;q=The+Starry+Night&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxY8YI7kFXv64JywVMGnNyWuMXlxEaBJS4WJzzSvJLKkUkuLikYLbrcEgxcUF5_EsYhUIyUhVCC5JLCqqVPDLTM8oAQDmNFnDqgAAAA&amp;npsic=0&amp;sa=X&amp;ved=0ahUKEwiL2_Hon4_hAhXNZt4KHTOAACwQ-BYILw" style="height:193px;width:120px" title="The Starry Night (1889)" role="button" data-hveid="47" data-ved="0ahUKEwiL2_Hon4_hAhXNZt4KHTOAACwQ-BYILw" id="target">
          <div class="klzc" style="margin-bottom:0">
            <div class="klic" style="height:120px;width:120px">
              <g-img class="BA0A6c" style="height:120px;width:120px">
                <img data-key="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQq3gOqqnprlNb3SdEgrKAR_0sWrsu0kO0aNnwE3yRwmA_cf-PvBvdz4eInim3FDmRn7E0" id="kximg0" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1" class="rISBZc M4dUYb" height="120" width="120" alt="">
              </g-img>
            </div>
          </div>
          <div>
            <div class="kltat">
              <span>The Starry </span>
              <wbr></wbr>
              <span>Night</span>
              <wbr></wbr>
            </div>
            <div class="ellip klmeta">1889</div>
          </div>
        </a>
      </html>
    HTML_NODE

    it "transforms the HTML node into an artwork object" do
      html_node = Nokogiri.parse(html_node_string)
      expect(
        GoogleThumbnailScraperV1.parse(html_node.css("a")[0]).as_json
      ).to match({
        "image" => expected_the_starry_night_base64_thumbnail,
        "link" => "https://www.google.com/search?gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxY8YI7kFXv64JywVMGnNyWuMXlxEaBJS4WJzzSvJLKkUkuLikYLbrcEgxcUF5_EsYhUIyUhVCC5JLCqqVPDLTM8oAQDmNFnDqgAAAA&npsic=0&sa=X&ved=0ahUKEwiL2_Hon4_hAhXNZt4KHTOAACwQ-BYILw",
        "name" => "The Starry Night",
        "extensions" => ["1889"]
      })
    end

    context "when there is no img base64 image present inside script html tag" do
      let(:html_node_string) { File.read("spec/fixtures/html_node_without_base_64.html") }

      it "transforms the HTML node into an artwork object with nil image" do
        html_node = Nokogiri.parse(html_node_string)
        expect(
          GoogleThumbnailScraperV1.parse(html_node.css("a")[0]).as_json
        ).to match({
          "image" => nil,
          "link" => "https://www.google.com/search?gl=us&hl=en&q=Self-portrait+without+beard&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLi1U_XNzRMKjfMMMkqK9RSyk620i_LLC5NzIlPLCpBYmYWl1iV5xdlFz9ijOQWePnjnrBUwKQ1J68xenERoUlIhYvNNa8ks6RSSIqLRwpuvwaDFBcXnMeziFU6ODUnTbcgv6ikKDGzRKE8syQjv7REISk1sSgFAFJ86rS5AAAA&npsic=0&sa=X&ved=0ahUKEwiL2_Hon4_hAhXNZt4KHTOAACwQ-BYIWQ",
          "name" => "Self-portrait without beard",
          "extensions" => ["1889"]
        })
      end
    end
  end
end
