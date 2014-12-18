class User < ActiveRecord::Base

  has_secure_password

  has_many :reviews, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password, length: { in: 6..20 }, on: :create
  validates :admin, inclusion: { in: [true, false] }

  def full_name
    "#{firstname} #{lastname}"
  end
end