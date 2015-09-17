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

    other.each { |k, v| send("#{k}=", v) if self.respond_to? "#{k}=" }
    # other.each do |k, v|
    #   self.send("#{k}=", v) if self.respond_to? "#{k}="
    # end
    self
  end
end
