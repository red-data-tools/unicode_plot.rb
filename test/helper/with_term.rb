require 'stringio'

module Helper
  module WithTerm
    def with_term
      sio = StringIO.new
      def sio.tty?; true; end

      orig_stdout, $stdout = $stdout, sio
      orig_env = ENV.to_h.dup
      ENV['TERM'] = 'xterm-256color'

      result = yield
      sio.close

      [result, sio.string]
    ensure
      $stdout.close
      $stdout = orig_stdout
      ENV.replace(orig_env) if orig_env
    end
  end
end
