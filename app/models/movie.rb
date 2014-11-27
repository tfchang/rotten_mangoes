class Movie < ActiveRecord::Base

  has_many :reviews, dependent: :destroy

  mount_uploader :poster_image, PosterImageUploader

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :release_date, presence: true

  validate :release_date_in_future

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
