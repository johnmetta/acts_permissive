module ActsPermissive
  module PermissiveLib

    def binary_owner
      255.to_s(2).rjust(8, '0')
    end

    def binary_admin
      127.to_s(2).rjust(8, '0')
    end

    def binary_write
      32.to_s(2).rjust(8, '0')
    end

    def binary_read
      16.to_s(2).rjust(8, '0')
    end

    def as_binary value
      value.to_s(2).rjust(8, '0')
    end

    def as_integer value
      value.to_i(2)
    end

    private

    def get_circle_for obj
      if obj.class == Circle
        obj
      elsif obj.is_used_permissively?
        obj.circle
      else
        raise "Argument must be a trust circle or an object that is used permissively"
      end
    end

    def create_guid!
      self.guid = UUIDTools::UUID.random_create.to_str if self.guid.nil?
    end


  end
end
