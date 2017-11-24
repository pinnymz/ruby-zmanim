module Zmanim::Util
  module TextHelper
    def titleize(string)
      string.to_s.gsub(/_/,' ').scan(/\w+/).map{|w| w[0].upcase + w[1..-1]}.join(' ')
    end
  end
end
