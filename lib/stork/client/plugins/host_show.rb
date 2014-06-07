module HostShowPlugin
  class HostShow < Stork::Plugin
    banner "stork host show HOST (options)"

    def run
      host = args.shift
      raise SyntaxError, "A host must be supplied" if host.nil?
      data = fetch("host/#{host}")
      show('name', data)
      show('distro', data)
      show('template', data)
      show('chef', data)
      show('run_list', data)
      show('pre_snippets', data)
      show('post_snippets', data)
      show('packages', data)
    end
  end
end
