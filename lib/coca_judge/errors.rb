module CocaJudge
  module JudgeError
    class Error < StandardError
    end

    class Runtime < StandardError
    end

    class TimeLimit < StandardError
    end

    class WrongAnswer < StandardError
    end

    class Compilation < StandardError
    end

    class Presentation < StandardError
    end
  end
end