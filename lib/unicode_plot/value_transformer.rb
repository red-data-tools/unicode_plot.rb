module UnicodePlot
  module ValueTransformer
    PREDEFINED_TRANSFORM_FUNCTIONS = {
      log10: Math.method(:log10)
    }.freeze

    def transform_values(func, values)
      return values unless func

      unless func.respond_to?(:call)
        func = PREDEFINED_TRANSFORM_FUNCTIONS[func]
        unless func.respond_to?(:call)
          raise ArgumentError, "func must be callable"
        end
      end

      case values
      when Numeric
        func.(values)
      else
        values.map(&func)
      end
    end

    module_function def transform_name(func, basename="")
      return basename unless func
      case func
      when String, Symbol
        name = func
      when ->(f) { f.respond_to?(:name) }
        name = func.name
      else
        name = "custom"
      end
      "#{basename} [#{name}]"
    end
  end
end
