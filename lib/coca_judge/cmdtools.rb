require 'active_support/core_ext/object/blank'
require 'coca_judge/errors'
require 'coca_judge/os_check'
require 'timeout'
require 'open3'

module CocaJudge
  class CmdTools
    @@proc_opts = {
      rlimit_as: Process.getrlimit(:AS),
      rlimit_core: Process.getrlimit(:CORE),
      rlimit_cpu: Process.getrlimit(:CPU),
      rlimit_data: Process.getrlimit(:DATA),
      rlimit_fsize: Process.getrlimit(:FSIZE),
      rlimit_memlock: Process.getrlimit(:MEMLOCK),
      rlimit_nofile: Process.getrlimit(:NOFILE),
      rlimit_nproc: Process.getrlimit(:NPROC),
      rlimit_rss: Process.getrlimit(:RSS),
      rlimit_stack: Process.getrlimit(:STACK),
      unsetenv_others: true,
      pgroup: true,
      umask: 022,
      close_others: true
    }

    unless OS.unix?
      @@proc_opts.merge!({
        rlimit_msgqueue: Process.getrlimit(:MSGQUEUE),
        rlimit_nice: Process.getrlimit(:NICE),
        rlimit_rtprio: Process.getrlimit(:RTPRIO),
        rlimit_sbsize: Process.getrlimit(:SBSIZE),
        rlimit_sigpending: Process.getrlimit(:SIGPENDING)
      })
    end

    class << self
      def proc_opts=(opthash)
        @@proc_opts.merge!(opthash) if opthash.is_a?(Hash)
      end

      def cli(cmd:, inputfile: nil, outputfile: nil, timeout: 10, opts: nil)
        options = opts.is_a?(Hash) ? @@proc_opts.merge(opts) : @@proc_opts
        outputcmd = outputfile ? "> #{outputfile}" : ""
        inputcmd = inputfile ? "< #{inputfile}" : ""
        cmdstr = "time -p #{cmd} #{inputcmd} #{outputcmd}"

        # stdout, stderr pipes
        rout, wout = IO.pipe
        rerr, werr = IO.pipe

        pid = Process.spawn(cmdstr, options.merge(out: wout, err: werr))

        begin
          status = nil
          if timeout
            Timeout.timeout(timeout) do
              _, status = Process.wait2(pid)
            end
          else
            _, status = Process.wait2(pid)
          end
          raise JudgeError::Error if status.exitstatus != 0
        rescue Timeout::Error
          Process.kill('TERM', pid)
          raise JudgeError::TimeLimit
        end

        # close write ends so we could read them
        wout.close
        werr.close

        results = {}
        rerr.each_line do |line|
          unless line.blank?
            result_type, result = line.split(/\s/)
            results[result_type] = result.to_f
          end
        end

        # dispose the read ends of the pipes
        rout.close
        rerr.close

        results
      end
    end
  end
end