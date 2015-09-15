class Struct
  # Insert/update object/hash data on the fly.
  #
  #   o = Struct.new
  #   o.merge!(:a => 2)
  #   o.a  #=> 2
  #
  def merge!(other)
    raise TypeError, "can't modify frozen #{self.class}", caller(1) \
      if self.frozen?

    # Do we actually want to each over the attributes?
    other.each do |k, v|
      # Only set if the member exists
      self.send("#{k}=", v)
    end
    self
  end
end
