module ActsPermissive
  module PermissionMap
    class << self
      def const_set(*args)
        @@hash = nil
        super
      end

      def hash
        @@hash ||= begin
          bitwise_hash = constants.inject({}) do |hash, constant_name|
            hash[constant_name.downcase] = 2 ** ActsPermissive::PermissionMap.const_get(constant_name.to_sym)
            hash
          end
          inverted_hash = bitwise_hash.invert
          bitwise_hash.values.sort.inject(ActiveSupport::OrderedHash.new) do |hash, value|
            hash[inverted_hash[value].to_sym] = value
            hash
          end
        rescue TypeError
          raise ActsPermissive::PermissiveError.new("Permissions must be integers or longs. Strings, symbols, and floats are not currently supported.")
        end
      end
    end
  end
end