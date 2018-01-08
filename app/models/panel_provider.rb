class PanelProvider < ActiveRecord::Base
  PRICE_TYPES = {
    'PRICE_ARRAY' => PriceLogic::Counter::ArrayCounter,
    'PRICE_CHAR' => PriceLogic::Counter::HTMLNodeCounter,
    'PRICE_NODE' => PriceLogic::Counter::CharacterCounter,
  }

  has_many :countries
  has_many :location_groups
  validates :price_type, :inclusion => {:in => PRICE_TYPES.keys }
  validates :code, presence: true, uniqueness: true

  def price
    PRICE_TYPES[price_type].get_price
  end
end
