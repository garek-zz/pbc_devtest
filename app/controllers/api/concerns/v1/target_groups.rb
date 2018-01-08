module Api
  module Concerns
    module V1
      module TargetGroups
        extend ActiveSupport::Concern

        included do
          before_filter :load_target_groups, only: :list
        end

        def load_target_groups
          @country = Country.find_by_country_code(params[:country_code])
          return unless @country

          @target_groups = @country.target_groups.where(panel_provider: @country.panel_provider)
        end
      end
    end
  end
end
