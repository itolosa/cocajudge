require 'coca_judge/errors'

module CocaJudge
  module Submit
    extend ActiveSupport::Concern
    #time offset in seconds
    TimeOffset = 1000

    def submit langname:, source:, bin_name: 'm', timeout: 1, masterfile: 'master.output', inputfile: 'all.input', outputfile: 'all.output', wdir: '.'
      handler = get_handler(langname)
      Dir.chdir(File.expand_path(wdir)) do
        handler.compile(source: source, outputbin: bin_name)
        stats = handler.run(inputbin: bin_name, inputfile: inputfile, outputfile: outputfile, timeout: timeout + TimeOffset)
        handler.checktime(stats: stats, timeout: timeout)
        handler.compare(file1: masterfile, file2: outputfile)
      end
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