# frozen_string_literal: true

require "json"

describe ImageParser do
  let(:html_string) { File.read(test_file) }

  subject { ImageParser.new(html_string:) }

  context "when van-gogh-paintings.html file es provided" do
    let(:test_file) { "files/van-gogh-paintings.html" }

    # This test will show a friendly diff if something goes wrong
    it "checks artworks array is right (this test must print a pretty diff if something goes wrong)" do
      expected_array = JSON.parse(File.read("files/expected-array.json"))["artworks"]
      aggregate_failures do
        subject.parse["artworks"].each_with_index do |artwork, i|
          expect(artwork).to match(expected_array[i])
        end
      end
    end

    it "matches the fixture file" do
      expected_hash = JSON.parse(File.read("files/expected-array.json"))
      expect(subject.parse).to match(expected_hash)
    end
  end

  context "when leonardo-da-vinci-paintings.html file es provided" do
    let(:test_file) { "spec/fixtures/leonardo-da-vinci-paintings.html" }

    # This test will show a friendly diff if something goes wrong
    it "checks artworks array is right (this test must print a pretty diff if something goes wrong)" do
      expected_array = JSON.parse(File.read("spec/fixtures/leonardo-da-vinci-paintings.json"))["artworks"]
      artworks = subject.parse["artworks"]
      aggregate_failures do
        expect(artworks.length).to be > 0
        artworks.each_with_index do |artwork, i|
          expect(artwork).to match(expected_array[i])
        end
      end
    end
  end
end
