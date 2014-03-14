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
  module DSL
    module Base
      module ClassMethods
        def objs
          @objs ||= {}
        end

        def classes
          @classes ||= Midwife::DSL.constants.select { |c| 
            Class === Midwife::DSL.const_get(c) 
          }.map { |c|
            c.downcase
          }
        end

        def clear
          @objs = nil
        end

        def find(name)
          objs[name] || nil
        end

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

        def attributes
          @attributes ||= []
        end

        def types
          @types ||= {}
        end

        def multis
          @multis ||= []
        end

        def file(sym, args={})
          file_attribute(sym)
        end

        def array(sym, args={})
          attribute(sym, [Array], args)
        end

        def string(sym, args={})
          attribute(sym, [String], args)
        end

        def symbol(sym, args={})
          attribute(sym, [Symbol], args)
        end

        def integer(sym, args={})
          attribute(sym, [Fixnum], args)
        end

        def boolean(sym, args={})
          attribute(sym, [TrueClass, FalseClass], args)
        end

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

        def file_attribute(sym)
          create_file_accessors(sym)
          attributes << sym
          types[sym] = String
        end

        def build(name, *args, &block)
          obj = delegate_build(name, *args, &block)
          objs[name] = obj
        end

        def delegate_build(name, *args, &block)
          obj = new(name)
          delegator = BuildDelegator.new(obj)
          delegator.instance_eval(&block) if block_given?
          obj
        end

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
              @#{name.to_s} = value
            end
          EOS
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      attr_reader :name
      def initialize(name)
        @name = name
      end
    end
  end
end