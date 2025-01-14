# encoding: UTF-8
#
# Copyright (c) 2010-2017 GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require_relative '../base_type'

require 'gooddata/extensions/class'

module GoodData
  module LCM2
    module Type
      class ComplexType < BaseType
        CATEGORY = :complex

        def to_s
          class_params = (self.class.const_defined?(:PARAMS) && self.class.const_get(:PARAMS)) || {}
          params = class_params.keys.map do |key|
            param = class_params[key]
            [param[:name], param[:type]] if param[:opts][:required]
          end

          params.compact!

          params = params.map do |param|
            param.join(': ')
          end

          "#{self.class.short_name}<#{params.join(', ')}>"
        end
      end
    end
  end
end
