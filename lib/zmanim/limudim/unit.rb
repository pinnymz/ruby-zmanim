module Zmanim::Limudim
  class Unit
    attr_reader :components
    def initialize(*components)
      @components = components
    end

    def to_s
      render{|value| value }
    end

    def render
      primary, secondary = components.map do |component|
        Array(component).map{|v| yield v}
      end
      render_with_root(primary) + render_secondary(secondary, primary)
    end

    private

    def render_with_root(component)
      root, extension = component.first, component[1..-1]
      return root.to_s if extension.length == 0
      "#{root} #{render_extension(extension)}"
    end

    def render_extension(extension)
      extension.join(':')
    end

    def render_secondary(second_component, first_component)
      if second_component.nil?
        return ''
      elsif second_component.first != first_component.first
        ' - ' + render_with_root(second_component)
      elsif diff = render_difference(second_component, first_component)
        '-' + diff
      else
        ''
      end
    end

    def render_difference(rendering, comparing)
      if rendering.length == 0
        return nil
      elsif rendering.first != comparing.first
        render_extension(rendering)
      else
        render_difference(rendering[1..-1], comparing[1..-1])
      end
    end
  end
end
