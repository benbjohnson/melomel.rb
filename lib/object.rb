class Object
  # Recursively generates an object proxy for the object if it is a Hash or
  # and Array.
  #
  # bridge - The bridge to use when generating a proxy.
  #
  # Returns a Melomel::ObjectProxy if it is a Hash or an Array. Otherwise
  # returns the object itself.
  def to_object_proxy(bridge)
    proxy = self

    # Convert each key/value pair in a Hash
    if self.is_a?(Hash)
      proxy = bridge.create_object('Object')
      each_pair do |k,v|
        v = v.to_object_proxy(bridge) unless v.nil?
        proxy.set_property!(k, v)
      end
    # Convert each item in an Array.
    elsif is_a?(Array)
      proxy = bridge.create_object('Array')
      each do |item|
        item = item.to_object_proxy(bridge) unless item.nil?
        proxy.push!(item)
      end
    end
    
    return proxy
  end
end