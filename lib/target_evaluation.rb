class TargetEvaluation
  attr_reader :country, :target_group, :locations, :errors

  def initialize(country_code, target_group_id, locations_array=[])
    @errors          = {}
    @country      = Country.find_by_country_code(country_code)
    @target_group = TargetGroup.find_by_id(target_group_id)
    @locations    = locations_array.map {|location| Location.find_by_id(location[:id]) }
  end

  def evaluate
    @country.panel_provider.price if valid?
  end

  def valid?
    validate_country_code
    validate_target_group_id
    validate_locations

    @errors.empty?
  end

  private

  def validate_country_code
    @errors[:country_code] = 'Country not found' unless @country
  end

  def validate_target_group_id
    @errors[:target_group_id] = 'TargetGroup not found' unless @target_group
  end

  def validate_locations
    @errors[:locations] = 'Location not found' unless @locations.all?
  end
end