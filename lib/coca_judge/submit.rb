require 'coca_judge/errors'

module CocaJudge
  module Submit
    #time offset in seconds
    TimeOffset = 1
    module ClassMethods
      def submit langname, source
        handler = get_handler(langname)
        handler.compile(source: source, outputbin: 'm')
        stats = handler.run(inputbin: 'm', timeout: 1 + 1000)
        handler.checktime(stats: stats, timeout: 1)
        handler.compare(file1: 'master.output', file2: 'all.output')
        puts 'OK'
      rescue JudgeError::Runtime
        puts 'RUNTIME ERROR'
      rescue JudgeError::WrongAnswer
        puts 'WRONG ANSWER'
      rescue JudgeError::Compilation
        puts 'COMPILATION ERROR'
      rescue JudgeError::TimeLimit
        puts 'TIMELIMIT ERROR'
      end
    end
  end
end