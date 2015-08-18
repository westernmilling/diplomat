class FormEntry
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def merge_hash(hash)
    hash.each do |k, v|
      self[k] = v
    end
    self
  end
end
