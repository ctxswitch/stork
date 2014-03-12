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
    class Option
      attr_reader :name, :type, :required, :default_value, :boolean, :not_if, :unsets

      def initialize(name, args = {})
        @name = name.to_s
        @value = nil
        @required = args.has_key?(:required) ? args[:required] : false
        @type = args.has_key?(:type) ? args[:type] : String
        @as = args.has_key?(:as) ? args[:as] : nil
        @default_value = args.has_key?(:default) ? args[:default] : nil
        @boolean = args.has_key?(:boolean) ? args[:boolean] : false
        @not_if = args.has_key?(:not_if) ? args[:not_if] : nil
        @unsets = args.has_key?(:unsets) ? args[:unsets] : nil
        validate!
      end

      def as
        @as ? @as : @name
      end

      def unset
        @value = boolean ? false : nil
      end

      def is_unset?
        @value.nil? || @value == false
      end

      def value=(value)
        validate_value!(:value, value)
        @value = value
      end

      def value
        if @value.nil?
          default_value
        else 
          @value
        end
      end

      def emit
        if value
          str = "--#{as}"
          str += "=#{value}" unless boolean
          str
        else
          ""
        end
      end

    private
      def validate!
        validate_value!(:default_value, value)
        validate_value!(:value, value)
      end

      def validate_value!(symbol, value)
        if boolean
          unless value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.is_a?(NilClass)
            raise TypeError, "#{symbol}: expected true/false"
          end
        else
          unless value.is_a?(type) || value.is_a?(NilClass)
            raise TypeError, "#{symbol}: expected #{type}, got #{default_value.class}"
          end
        end
      end
    end
  end
end
