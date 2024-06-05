class User < ApplicationRecord
  before_validation :generate_uuid
  validates :name, presence: true
  validates :uuid, uniqueness: true, presence: true
  has_many :posts, dependent: :destroy

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
