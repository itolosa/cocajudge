require 'coca_judge/cmdtools'

module CocaJudge
  module LangHandlers
    class CHandler
      TimeOffset = 1000

      class << self
        def run(inputbin:, inputfile: 'all.input', outputfile: 'all.output', timeout: nil)
          CmdTools.cli cmd: "./#{inputbin}", inputfile: inputfile, outputfile: outputfile, timeout: timeout
        end

        def compile(source:, outputbin: 'm', outputfile: 'output.gcc')
          CmdTools.cli cmd: "gcc #{source} -o #{outputbin}", outputfile: outputfile
        end
      end
    end
  end
end