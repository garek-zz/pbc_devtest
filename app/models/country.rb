class Country < ActiveRecord::Base
  belongs_to :panel_provider
  has_many :location_groups
  has_and_belongs_to_many :target_groups, before_add: :check_target_group_root?

  validates :country_code, presence: true, uniqueness: true
  validates :panel_provider_id, presence: true

  private

  def check_target_group_root?(target_group)
    raise ActiveRecord::Rollback unless target_group.root?
  end
end
