require 'coca_judge/handler'
require 'coca_judge/submit'

module CocaJudge
  class Core
    extend LangHandler
    include Submit
  end
end