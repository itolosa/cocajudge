require 'coca_judge/handler_wrapper'
require 'active_support/core_ext/string/inflections'

module CocaJudge
  module LangHandler
    mattr_reader(:lang_handlers) { Hash.new }

    def lang_handlers=(list_of_handlers)
      list_of_handlers.each do |name, handler|
        case handler
        when Class
          @@lang_handlers[name] = HandlerWrapper.new(handler)
        end
      end
    end

    def get_handler(name)
      @@lang_handlers[name] ||= HandlerWrapper.new(load_handler(name))
    end

    private
      def load_handler(name)
        require "coca_judge/lang_handlers/#{name}_handler"
        "CocaJudge::LangHandlers::#{name.to_s.camelize}Handler".constantize
      end
  end
end