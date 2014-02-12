module Midwife
  module Core
    def builder
      self.class.builder
    end

    # def distros
    #   self.class.distros
    # end

    # def domains
    #   self.class.domains
    # end

    # def schemes
    #   self.class.schemes
    # end

    # def hosts
    #   self.class.hosts
    # end

    # def templates
    #   self.class.templates
    # end

    module ClassMethods
      def builder
        @@builder ||= Midwife::Builder.build
      end

      def export(builder)
        @@builder = builder
      end

      # def distros
      #   @@distros ||= Midwife::Build::Distros.build
      # end

      # def domains
      #   @@domains ||= Midwife::Build::Domains.build
      # end

      # def schemes
      #   @@schemes ||= Midwife::Build::Schemes.build
      # end

      # def hosts
      #   @@hosts ||= Midwife::Build::Hosts.build
      # end

      # def templates
      #   # builder.templates
      # end

      def find(name)
        builder.find(self, name)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
