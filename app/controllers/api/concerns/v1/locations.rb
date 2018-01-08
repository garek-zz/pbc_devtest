module Api
  module Concerns
    module V1
      module Locations
        extend ActiveSupport::Concern

        included do
          before_filter :load_locations, only: :list
        end

        def load_locations
          @country = Country.find_by_country_code(params[:country_code])
          return unless @country

          @location_groups = @country.location_groups.where(panel_provider: @country.panel_provider)
          @locations       = @location_groups.map(&:locations).flatten
        end
      end
    end
  end
end
