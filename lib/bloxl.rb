require 'axlsx'

module BloXL
  %w[builder sheet book stylesheet style style_element chart chart_labels].each do |mod|
    require_relative "bloxl/#{mod}"
  end

  class << self
    extend Forwardable
    def_delegators Book, :open
  end
end
