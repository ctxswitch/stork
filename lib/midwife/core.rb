module Midwife
  module Core
    def domains
      self.class.domains
    end

    def schemes
      self.class.schemes
    end

    def hosts
      self.class.hosts
    end

    def templates
      self.class.templates
    end

    module ClassMethods
      def domains
        @@domains ||= Midwife::DSL::Domains.build
      end

      def schemes
        @@schemes ||= Midwife::DSL::Schemes.build
      end

      def hosts
        @@hosts ||= Midwife::DSL::Hosts.build
      end

      def templates
        @@templates ||= Dir.glob("#{Midwife.configuration.path}/templates/*.erb").inject({}) do |tmpls, filename|
          name = File.basename(filename, '.erb')
          tmpls[name] = File.read(filename)
          tmpls
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
