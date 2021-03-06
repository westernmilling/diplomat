require 'ostruct'

class OpenStruct
  # Insert/update hash data on the fly.
  #
  #   o = OpenStruct.new
  #   o.merge!(:a => 2)
  #   o.a  #=> 2
  #
  def merge!(other)
    raise TypeError, "can't modify frozen #{self.class}", caller(1) \
      if self.frozen?

    other.each do |k, v|
      @table[k.to_sym] = v
    end
    self
  end
end
