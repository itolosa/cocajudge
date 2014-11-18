require 'coca_judge/lang_handler'
require 'coca_judge/submit'

module CocaJudge
  class Base
    include LangHandler
    include Submit
  end
end