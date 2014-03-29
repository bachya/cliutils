#  ======================================================
#  Hash Class
#
#  Contains many convenient methods borrowed from Rails
#  http://api.rubyonrails.org/classes/Hash.html
#  ======================================================
class Hash
  #  ====================================================
  #  Methods
  #  ====================================================
  #  ----------------------------------------------------
  #  deep_merge! method
  #
  #  Deep merges a hash into the current one.
  #  @param other_hash The hash to merge in
  #  @param &block
  #  @return Hash
  #  ----------------------------------------------------
  def deep_merge!(other_hash, &block)
    other_hash.each_pair do |k,v|
      tv = self[k]
      if tv.is_a?(Hash) && v.is_a?(Hash)
        self[k] = tv.deep_merge(v, &block)
      else
        self[k] = block && tv ? block.call(k, tv, v) : v
      end
    end
    self
  end

  #  ----------------------------------------------------
  #  deep_stringify_keys method
  #
  #  Recursively turns all Hash keys into strings and
  #  returns the new Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_stringify_keys
    deep_transform_keys{ |key| key.to_s }
  end

  #  ----------------------------------------------------
  #  deep_symbolize_keys! method
  #
  #  Same as deep_stringify_keys, but destructively
  #  alters the original Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_stringify_keys!
    deep_transform_keys!{ |key| key.to_s }
  end

  #  ----------------------------------------------------
  #  deep_symbolize_keys method
  #
  #  Recursively turns all Hash keys into symbols and
  #  returns the new Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_symbolize_keys
    deep_transform_keys{ |key| key.to_sym rescue key }
  end

  #  ----------------------------------------------------
  #  deep_symbolize_keys! method
  #
  #  Same as deep_symbolize_keys, but destructively
  #  alters the original Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_symbolize_keys!
    deep_transform_keys!{ |key| key.to_sym rescue key }
  end

  #  ----------------------------------------------------
  #  deep_transform_keys method
  #
  #  Generic method to perform recursive operations on a
  #  Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_transform_keys(&block)
    _deep_transform_keys_in_object(self, &block)
  end

  #  ----------------------------------------------------
  #  deep_transform_keys! method
  #
  #  Same as deep_transform_keys, but destructively
  #  alters the original Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_transform_keys!(&block)
    _deep_transform_keys_in_object!(self, &block)
  end

  private

  #  ----------------------------------------------------
  #  _deep_transform_keys_in_object method
  #
  #  Modification to deep_transform_keys that allows for
  #  the existence of arrays.
  #  https://github.com/rails/rails/pull/9720/files?short_path=4be3c90
  #  @param object The object to examine
  #  @param &block A block to execute on the opject
  #  @return Object
  #  ----------------------------------------------------
  def _deep_transform_keys_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[yield(key)] = _deep_transform_keys_in_object(value, &block)
      end
    when Array
      object.map {|e| _deep_transform_keys_in_object(e, &block) }
    else
      object
    end
  end

  #  ----------------------------------------------------
  #  _deep_transform_keys_in_object! method
  #
  #  Same as _deep_transform_keys_in_object, but
  #  destructively alters the original Object.
  #  @param object The object to examine
  #  @param &block A block to execute on the opject
  #  @return Object
  #  ----------------------------------------------------
  def _deep_transform_keys_in_object!(object, &block)
    case object
    when Hash
      object.keys.each do |key|
        value = object.delete(key)
        object[yield(key)] = _deep_transform_keys_in_object!(value, &block)
      end
      object
    when Array
      object.map! {|e| _deep_transform_keys_in_object!(e, &block)}
    else
      object
    end
  end
end