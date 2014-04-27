# Hash Class
# Contains many convenient methods borrowed from Rails
# http://api.rubyonrails.org/classes/Hash.html
class Hash
  # Deep merges a hash into the current one. Returns
  # a new copy of the hash.
  # @param [Hash] other_hash The hash to merge in
  # @return [Hash] The original Hash
  def deep_merge(other_hash)
    self.merge(other_hash) do |key, oldval, newval|
      oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
      newval = newval.to_hash if newval.respond_to?(:to_hash)
      oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? oldval.deep_merge(newval) : newval
    end
  end

  # Deep merges a hash into the current one. Does
  # the replacement inline.
  # @param [Hash] other_hash The hash to merge in
  # @return [Hash] The original Hash
  def deep_merge!(other_hash)
    replace(deep_merge(other_hash))
  end

  # Recursively turns all Hash keys into strings and
  # returns the new Hash.
  # @return [Hash] A new copy of the original Hash
  def deep_stringify_keys
    deep_transform_keys { |key| key.to_s }
  end

  # Same as deep_stringify_keys, but destructively
  # alters the original Hash.
  # @return [Hash] The original Hash
  def deep_stringify_keys!
    deep_transform_keys! { |key| key.to_s }
  end

  # Recursively turns all Hash keys into symbols and
  # returns the new Hash.
  # @return [Hash] A new copy of the original Hash
  def deep_symbolize_keys
    deep_transform_keys { |key| key.to_sym rescue key }
  end

  # Same as deep_symbolize_keys, but destructively
  # alters the original Hash.
  # @return [Hash] The original Hash
  def deep_symbolize_keys!
    deep_transform_keys! { |key| key.to_sym rescue key }
  end

  # Generic method to perform recursive operations on a
  # Hash.
  # @yield &block
  # @return [Hash] A new copy of the original Hash
  def deep_transform_keys(&block)
    _deep_transform_keys_in_object(self, &block)
  end

  # Same as deep_transform_keys, but destructively
  # alters the original Hash.
  # @yield &block
  # @return [Hash] The original Hash
  def deep_transform_keys!(&block)
    _deep_transform_keys_in_object!(self, &block)
  end

  # Recursively searches a hash for the passed
  # key and returns the value (if there is one).
  # http://stackoverflow.com/a/2239847/327179
  # @param [<Symbol, String>] key The key to search for
  # @yield
  # @return [Multiple]
  def recursive_find_by_key(key)
    # Create a stack of hashes to search through for the needle which
    # is initially this hash
    stack = [ self ]

    # So long as there are more haystacks to search...
    while (to_search = stack.pop)
      # ...keep searching for this particular key...
      to_search.each do |k, v|
        # ...and return the corresponding value if it is found.
        return v if (k == key)

        # If this value can be recursively searched...
        if (v.respond_to?(:recursive_find_by_key))
          # ...push that on to the list of places to search.
          stack << v
        end
      end
    end
  end

  private

  # Modification to deep_transform_keys that allows for
  # the existence of arrays.
  # https://github.com/rails/rails/pull/9720/files?short_path=4be3c90
  # @param [Object] object The object to examine
  # @yield &block
  # @return [Object]
  def _deep_transform_keys_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[yield(key)] = _deep_transform_keys_in_object(value, &block)
      end
    when Array
      object.map { |e| _deep_transform_keys_in_object(e, &block) }
    else
      object
    end
  end

  # Same as _deep_transform_keys_in_object, but
  # destructively alters the original Object.
  # @param [Object] object The object to examine
  # @yield &block
  # @return [Object]
  def _deep_transform_keys_in_object!(object, &block)
    case object
    when Hash
      object.keys.each do |key|
        value = object.delete(key)
        object[yield(key)] = _deep_transform_keys_in_object!(value, &block)
      end
      object
    when Array
      object.map! { |e| _deep_transform_keys_in_object!(e, &block) }
    else
      object
    end
  end
end
