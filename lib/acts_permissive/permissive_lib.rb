module ActsAsFollower
  module PermissiveLib

    def to_bin value
      if value.class == String
        value.to_i(2)
      elsif value.class == Integer
        value.to_s(2).rjust(9)
      end
    end

    def owner
      to_bin 256
    end

    def admin
      to_bin 128
    end

    def read
      to_bin 64
    end

    def write
      to_bin 32
    end

  end
end
