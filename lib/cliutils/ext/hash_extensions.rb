# Hash Class
# Contains many convenient methods borrowed from Rails
# http://api.rubyonrails.org/classes/Hash.html
class Hash
  # Deep merges a hash into the current one.
  # @param [Hash] other_hash The hash to merge in
  # @yield &block
  # @return [Hash]
  def deep_merge!(other_hash, &block)
    other_hash.each_pair do |k, v|
      tv = self[k]
      if tv.is_a?(Hash) && v.is_a?(Hash)
        self[k] = tv.deep_merge(v, &block)
      else
        self[k] = block && tv ? block.call(k, tv, v) : v
      end
    end
    self
  end

  # Recursively turns all Hash keys into strings and
  # returns the new Hash.
  # @return [Hash]
  def deep_stringify_keys
    deep_transform_keys { |key| key.to_s }
  end

  # Same as deep_stringify_keys, but destructively
  # alters the original Hash.
  # @return [Hash]
  def deep_stringify_keys!
    deep_transform_keys! { |key| key.to_s }
  end

  # Recursively turns all Hash keys into symbols and
  # returns the new Hash.
  # @return [Hash]
  def deep_symbolize_keys
    deep_transform_keys { |key| key.to_sym rescue key }
  end

  # Same as deep_symbolize_keys, but destructively
  # alters the original Hash.
  # @return [Hash]
  def deep_symbolize_keys!
    deep_transform_keys! { |key| key.to_sym rescue key }
  end

  # Generic method to perform recursive operations on a
  # Hash.
  # @yield &block
  # @return [Hash]
  def deep_transform_keys(&block)
    _deep_transform_keys_in_object(self, &block)
  end

  # Same as deep_transform_keys, but destructively
  # alters the original Hash.
  # @yield &block
  # @return [Hash]
  def deep_transform_keys!(&block)
    _deep_transform_keys_in_object!(self, &block)
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
