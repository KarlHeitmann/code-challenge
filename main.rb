# frozen_string_literal: true

require_relative "lib/image_parser"

html_string = File.read(ARGV[0])
puts ImageParser.new(html_string:).parse
