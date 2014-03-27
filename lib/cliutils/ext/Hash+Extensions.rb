#  ======================================================
#  Hash Class
#
#  Contains many convenient methods borred from Rails
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
    result = {}
    each do |key, value|
      result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
    end
    result
  end

  #  ----------------------------------------------------
  #  deep_transform_keys! method
  #
  #  Same as deep_transform_keys, but destructively
  #  alters the original Hash.
  #  @return Hash
  #  ----------------------------------------------------
  def deep_transform_keys!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
    end
    self
  end
end