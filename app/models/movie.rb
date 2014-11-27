class Movie < ActiveRecord::Base

  has_many :reviews, dependent: :destroy

  mount_uploader :poster_image, PosterImageUploader

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :release_date, presence: true

  validate :release_date_in_future

  scope :query_title,         -> (q_title)    { where("title like ?", "%#{q_title}%") }
  scope :query_director,      -> (q_director) { where("director like ?", "%#{q_director}%") }
  scope :query_runtime_from,  -> (q_runtime)  { where("runtime_in_minutes >= ?", q_runtime) }
  scope :query_runtime_to,    -> (q_runtime)  { where("runtime_in_minutes <= ?", q_runtime) }

  def review_average
    reviews.average(:rating_out_of_ten)
  end

  private

  def release_date_in_future
    if release_date.present? && release_date < Date.today
      errors.add(:release_date, "should probably be in the future")
    end
  end
end
