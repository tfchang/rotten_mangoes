class User < ActiveRecord::Base

  has_secure_password

  has_many :reviews, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password, length: { in: 6..20 }, on: :create
  validates :admin, inclusion: { in: [true, false] }

  scope :query_name,  -> (q_name)     {
    q_name.blank? ? all : where("(firstname like ?) OR (lastname like ?)", "%#{q_name}%", "%#{q_name}%")
  }

  scope :query_email, -> (q_email)     {
    q_email.blank? ? all : where("email like ?", "%#{q_email}%")
  }

  def full_name
    "#{firstname} #{lastname}"
  end
end