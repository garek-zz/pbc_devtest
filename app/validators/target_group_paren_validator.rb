class TargetGroupParenValidator < ActiveModel::Validator
  def validate(record)
    return unless has_countries?(record)
    return if record.parent_id.nil?

    record.errors[:parent_id] << "parent_id must be nil"
  end

  private

  def has_countries?(record)
    record.countries.present?
  end
end