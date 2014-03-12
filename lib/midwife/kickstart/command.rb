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
  module Kickstart
    class Command
      class << self
        def options
          @options ||= {}
        end

        def name(name)
          @name = name
        end

        def command
          @name
        end

        def option(name, args = {})
          options[name.to_sym] = args

          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}
              options[:#{name}].value
            end
            
            def #{name}=(value)
              options[:#{name}].value = value

              unsets = options[:#{name}].unsets
              if unsets
                if unsets.is_a?(Array)
                  unsets.each do |opt|
                    options[opt].unset
                  end
                else
                  options[unsets].unset
                end
              end
            end
          EOS
        end

        def build(value = "", *args, &block)
          obj = new(value)
          delegator = BuildDelegator.new(obj, options)
          delegator.instance_eval(&block) if block_given?
          obj
        end

        class BuildDelegator < SimpleDelegator
          def initialize(obj, options)
            @options = options
            @delegated = obj
            super(obj)
          end

          def method_missing( name, *args, &block )
            sym = name.to_sym
            if @options[sym]
              if @options[sym][:boolean]
                @delegated.options[sym].value = args.empty? ? true : args.first
                unsets = @delegated.options[sym].unsets
                if unsets
                  if unsets.is_a?(Array)
                    unsets.each do |opt|
                      @delegated.options[opt.to_sym].unset
                    end
                  else
                    @delegated.options[unsets.to_sym].unset
                  end
                end
              else
                @delegated.options[sym].value = args.first
              end
            else
              raise SyntaxError, "#{name} is not a valid method."
            end
          end
        end
      end

      attr_reader :name, :value

      def initialize(value = "")
        @value = value
        @name = self.class.command
      end

      def options
        @options ||= options_init
      end

      def emit
        strs = []
        strs << name
        strs << value unless value.empty?
        options.keys.sort.each do |key|
          if options[key].value && option_can?(key)
            strs << options[key].emit
          end
        end
        strs.join(' ')
      end

    private
      def options_init
        h = {}
        self.class.options.each do |key, value|
          h[key] = Option.new(key, value)
        end
        h
      end

      def option_can?(key)
        not_if = options[key].not_if
        unless not_if.nil?
          options.keys.include?(not_if.to_sym) && options[not_if.to_sym].is_unset?
        else
          true
        end
      end

    end
  end
end