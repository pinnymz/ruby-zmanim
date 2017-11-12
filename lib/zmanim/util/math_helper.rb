module Zmanim::Util
  module MathHelper
    DEGREE_RADIAN_RATIO = 180.0/Math::PI
    refine Numeric do
      def to_radians
        self / DEGREE_RADIAN_RATIO
      end

      def to_degrees
        self * DEGREE_RADIAN_RATIO
      end
    end
  end
end
