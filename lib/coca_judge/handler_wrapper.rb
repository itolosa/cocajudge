require 'coca_judge/errors'
require 'coca_judge/cmdtools'

module CocaJudge
  class HandlerWrapper
    def initialize(h)
      @handler = h
      [:checktime, :compare].each do |n|
        if h.respond_to?(n)
          self.class.send(:define_method, n, &h.method(n))
        end
      end
    end

    def compile(*args)
      @handler.compile(*args)
    rescue JudgeError::Error
      raise JudgeError::Compilation
    end

    def run(*args)
      @handler.run(*args)
    rescue JudgeError::Error
      raise JudgeError::Runtime
    end

    def checktime(stats:, timeout:)
      raise JudgeError::TimeLimit if stats['real'] > timeout
    end

    def compare(file1:, file2:)
      CmdTools.cli cmd: "cmp --silent #{file1} #{file2}"
    rescue JudgeError::Error
      raise JudgeError::WrongAnswer
    end
  end
end