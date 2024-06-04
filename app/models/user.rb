class User < ApplicationRecord
  before_create :generate_uuid
  validates :name, presence: true
  validates :uuid, uniqueness: true, presence: true

  def generate_uuid
    uuid = SecureRandom.uuid
  end
end
