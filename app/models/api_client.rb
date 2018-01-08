class ApiClient < ActiveRecord::Base
  before_create :init_client_key

  private

  def init_client_key
    self.client_key = generate_client_key
  end

  def generate_client_key
    loop do
      token = SecureRandom.uuid.gsub(/\-/,'')
      break token unless ApiClient.exists?(client_key: token)
    end
  end
end
