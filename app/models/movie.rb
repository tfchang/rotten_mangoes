class Movie < ActiveRecord::Base

  RUNTIME_NA = -1                     # if runtime is N/A
  REALEASE_NA = Date.new(1000, 1, 1)  # if release date is N/A

  has_many :reviews, dependent: :destroy

  mount_uploader :poster_image, PosterImageUploader

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :release_date, presence: true
  # validate :release_date_in_future

  scope :query_title,         -> (q_title)    { 
    q_title.blank? ? all : where("title like ?", "%#{q_title}%") 
  }
  scope :query_director,      -> (q_director) { 
    q_director.blank? ? all : where("director like ?", "%#{q_director}%") 
  }
  scope :query_name,          -> (q_name)     {
    q_name.blank? ? all : where("(title like ?) OR (director like ?)", "%#{q_name}%", "%#{q_name}%")
  }
  scope :query_runtime_from,  -> (q_runtime)  { 
    q_runtime.blank? ? all : where("runtime_in_minutes >= ?", q_runtime)
  }
  scope :query_runtime_to,    -> (q_runtime)  { 
    q_runtime.blank? ? all : where("runtime_in_minutes <= ?", q_runtime) 
  }

  def self.load_omdb(imdb_id, title)
    query = "http://www.omdbapi.com/?"
    result = ""

    # Search by IMDB ID first
    if imdb_id.present?
      i_query = query + "i=" + imdb_id  
      # query << rand(MAX_ID).to_s << "&plot=short&r=json"
      open(i_query) { |f| result = f.each_line.first }
    end

    # If not finding movie by IMDB ID, search by title 
    if result.blank? && title.present?
      t_query = query + "t=" + title
      open(t_query) { |f| result = f.each_line.first }
    end

    result.blank? ? result : parse_omdb(result)
  end

  def self.parse_omdb(str)
    omdb_hash = JSON.parse(str)
    movies = {}

    omdb_hash.each do |key, value| 
      case key
        when "Title", "Director"
          movies[key.downcase.to_sym] = value
        when "Plot"
          movies[:description] = value
        when "Runtime"
          movies[:runtime_in_minutes] = 
            value == "N/A" ? RUNTIME_NA : value[0..-5].to_i
        when "Released" 
          movies[:release_date] = 
            value == "N/A" ? REALEASE_NA : Date.strptime(value, "%d %b %Y")
      end
    end

    movies
  end

  def review_average
    reviews.average(:rating_out_of_ten)
  end

  # private

  # This method was required in the tutorial, but it makes no sense to include only
  # upcoming movies on a review website 
  #  
  # def release_date_in_future
  #   if release_date.present? && release_date < Date.today
  #     errors.add(:release_date, "should probably be in the future")
  #   end
  # end
end
