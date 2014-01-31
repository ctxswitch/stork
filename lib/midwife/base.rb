module Midwife
  module Base
    def environment
      @_env ||= {}
    end

    def env
      ENV['MIDWIFE_ENV'] || 'development'
    end
    
    def set_config(config)
      environment['config'] = config
    end

    def partitions
      environment['config'].partitions
    end

    def templates
      environment['config'].templates
    end

    def hosts
      environment['config'].hosts
    end

    def domains
      environment['config'].domains
    end

    def midwife
      environment['config'].midwife
    end

    def url
      environment['url']
    end

    def pxe_path
      environment['pxe_path']
    end
  end
end