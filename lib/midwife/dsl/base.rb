# Copyright 2012, Rob Lyon
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module Midwife
  # The Midwife DSL allows you to programatically define and configure host
  # parameters and attributes.  The resulting host is passed to the kickstart
  # generation tool for 'bare metal' or vm provisioning.
  #
  # = A simple host definition
  #
  # Host objects can be generated using the build method.
  #
  #  @host = Midwife::DSL::Host.build "example.com" do
  #    distro "centos6" do
  #      url "http://localhost/centos6"
  #      kernel "vmlinuz"
  #      initrd "initrd.img"
  #    end
  #
  #    chef "chef.example.com" do
  #      version           "11.4.4"
  #      client_name       "root"
  #      client_key        "./specs/files/snakeoil-root.pem"
  #      validator_name    "validator"
  #      validation_key    "./specs/files/snakeoil-validation.pem"
  #      encrypted_data_bag_secret "mysecret"
  #    end
  #
  #    scheme "rootandhome" do
  #      partition "/" do
  #        size 8192
  #        type "ext4"
  #      end
  #      partition "/home" do
  #        size 1
  #        grow
  #      end
  #    end
  #
  #    net 'eth0' do
  #      domain 'local' do
  #        netmask '255.255.255.0'
  #        gateway '192.168.1.1'
  #        nameserver '192.168.1.253'
  #        nameserver '192.168.1.252'
  #        ntpserver '192.168.1.253'
  #        ntpserver '192.168.1.252'
  #      end
  #      bootproto :static
  #      ip        '192.168.1.100'
  #    end
  #    
  #    template "default"
  #
  #    pxemac    '00:11:22:33:44:55'
  #    run_list  %w{recipe[sudo] recipe[authentication] recipe[nagios] recipe[apache]}
  #    timezone  'America/Los_Angeles'
  #    selinux   :permissive
  #    password  'ummm'
  #  end
  #
  # If one of the dsl objects that can be passed blocks is called without a block, 
  # midwife will assume that it has been previously defined and try to find it.
  #
  # e.g.
  #
  #    net 'eth0' do
  #      domain 'local'
  #      bootproto :static
  #      ip        '192.168.1.100'
  #    end
  #
  module DSL
    # The base module defines several helper methods that allow the addition of new 
    # definition blocks and supports the inline blocks as well as stored definitions 
    # that can be reused.  These methods are meant to be included in every class that
    # will be used for building hosts or other configuration details.
    module Base
      module ClassMethods
        # By default, only the predefined 'native' objects can be used
        # in when processing the code blocks.
        # This is used to nest other midwife objects into the structure.
        def allow_objects(*objs)
          objs.each do |obj|
            klass = Midwife::DSL.const_get(obj.capitalize)
            class_eval <<-EOS, __FILE__, __LINE__
              def self.#{obj.to_s}(name, args={})
                attribute(name, [#{klass}], args)
              end
            EOS
          end
        end

        # All attributes that have been defined.
        def attributes
          @attributes ||= []
        end

        # Classwide storage of all objects that are created using build.
        def objs
          @objs ||= {}
        end

        # Gather all DSL classes.  Used to verify that objects that we
        # are allowing to be nested are actually valid
        def classes
          @classes ||= Midwife::DSL.constants.select { |c| 
            Class === Midwife::DSL.const_get(c) 
          }.map { |c|
            c.downcase
          }
        end

        # Remove all stored objects.  Used for testing
        def clear
          @objs = nil
        end

        # Find a previously built object that is stored globaly
        def find(name)
          objs[name] || nil
        end

        # Store the valid types for the attributes.
        def types
          @types ||= {}
        end

        # Keep a record of the attributes that are allowed to have multiple values.
        def multis
          @multis ||= []
        end

        # Define a file attribute type.  Whenever the attribute is set, it takes the
        # string value that is passed to it, uses it as a file path and reads in the
        # data
        def file(sym, args={})
          file_attribute(sym)
        end

        # Define an array attribute type.  Not the same as multi.  Just sets up 
        # validation and accessors to handle an array as the input
        def array(sym, args={})
          attribute(sym, [Array], args)
        end

        # Define a string attribute type
        def string(sym, args={})
          attribute(sym, [String], args)
        end

        # Define a symbol attribute type
        def symbol(sym, args={})
          attribute(sym, [Symbol], args)
        end

        # Define an integer attribute type
        def integer(sym, args={})
          attribute(sym, [Fixnum], args)
        end

        # Define a boolean attribute type that only accepts true or false
        def boolean(sym, args={})
          attribute(sym, [TrueClass, FalseClass], args)
        end

        # Create a dsl attribute.
        def attribute(sym, type, args={})
          multi = args.has_key?(:multi) ? args[:multi] : false

          if multi
            create_multi_accessors(sym, type)
            multis << sym
          else
            create_accessors(sym, type)
          end

          attributes << sym
          types[sym] = type
        end

        # Create a file attributes
        def file_attribute(sym)
          create_file_accessors(sym)
          attributes << sym
          types[sym] = String
        end

        # Send to the delegator and persist the object.
        def build(name, *args, &block)
          obj = delegate_build(name, *args, &block)
          objs[name] = obj
        end

        # Create the object and send it to the delegator.  Evaluate any blocks.
        # I split this off from the build because we needed the build delegation
        # without persisting the object at the class level when inline object
        # definitions are found
        def delegate_build(name, *args, &block)
          obj = new(name)
          delegator = BuildDelegator.new(obj)
          delegator.instance_eval(&block) if block_given?
          obj
        end

        # Delegate the build so we isolate the DSL from all of our special
        # attribute definitions and global class variables
        class BuildDelegator < SimpleDelegator
          def initialize(obj)
            @delegated = obj
            super(obj)
          end

          def method_missing( sym, *args, &block )
            unless @delegated.class.attributes.include?(sym)
              raise SyntaxError, "#{sym} is not a valid method."
            end

            if @delegated.class.classes.include?(sym)
              name = args.first
              if block_given?
                obj = Midwife::DSL.const_get(sym.capitalize).delegate_build(name, &block)
              else
                obj = Midwife::DSL.const_get(sym.capitalize).find(name)
              end
            else
              obj = args.first || true
            end

            if @delegated.class.multis.include?(sym)
              @delegated.send(:"add_#{sym.to_s}", obj)
            else
              @delegated.send(:"#{sym.to_s}=", obj)
            end
          end
        end

      private
        # Create the standard accessors
        def create_accessors(name, type)
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name.to_s}
              @#{name.to_s}
            end

            def #{name.to_s}=(value)
              unless #{type}.include?(value.class)
                raise TypeError, "#{name} expected a `#{type.join('|')}' value, " + value.class.to_s + " found"
              end

              @#{name.to_s} = value
            end
          EOS
        end

        # Create the accessors for the types that can be specified multiple times.
        # everytime the attribute is set it will add it to an array of values instead
        # of overwriting the previous values.
        def create_multi_accessors(name, type)
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name.to_s}s
              @#{name.to_s}s ||= []
            end

            def add_#{name.to_s}(value)
              unless #{type}.include?(value.class)
                raise TypeError, "#{name} expected a `#{type.join('|')}' value, " + value.class.to_s + " found"
              end

              #{name.to_s}s << value
            end
          EOS
        end

        # Create the file accessors.  Everytime the value is changed, the file is
        # re-read and the cached contents cleared.
        def create_file_accessors(name)
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name.to_s}
              @#{name}_contents ||= File.read(@#{name.to_s})
            end

            def #{name.to_s}=(value)
              unless value.is_a?(String)
                raise SyntaxError, "#{name} expected a `String' value, ` + value.class + ' found"
              end

              unless File.exists?(value)
                raise FileNotFound, value + " was no where to be found."
              end
              @#{name}_contents = nil
              @#{name.to_s} = value
            end
          EOS
        end
      end

      # Include me!!!!
      def self.included(base)
        base.extend(ClassMethods)
      end

      attr_reader :name

      # Initialize me!!!!
      def initialize(name)
        @name = name
      end
    end
  end
end