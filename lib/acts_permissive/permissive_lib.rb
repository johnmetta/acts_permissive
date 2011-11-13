module ActsPermissive
  module PermissiveLib

    def to_bin value
      if value.class == String
        value.to_i(2)
      elsif value.class == Integer
        value.to_s(2).rjust(9,'0')
      end
    end

    def owner_bin_string
      to_bin 256
    end

    def admin_bin_string
      to_bin 128
    end

    def write_bin_string
      to_bin 64
    end

    def read_bin_string
      to_bin 32
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
