require 'stringio'

module Helper
  module WithTerm
    def with_sio(tty: true)
      sio = StringIO.new
      def sio.tty?; true; end if tty

      result = yield(sio)
      sio.close

      [result, sio.string]
    end

    def with_term(tty=true)
      with_sio(tty: tty) do |sio|
        orig_stdout, $stdout = $stdout, sio
        orig_env = ENV.to_h.dup
        ENV['TERM'] = 'xterm-256color'
        yield
      ensure
        $stdout = orig_stdout
        ENV.replace(orig_env) if orig_env
      end
    end
  end
end
