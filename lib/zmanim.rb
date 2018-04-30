require 'tzinfo'

module Zmanim; end
module Zmanim::Limudim; end

Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|file| require file }
