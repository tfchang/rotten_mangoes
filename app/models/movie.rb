class Movie < ActiveRecord::Base

  MAX_ID = 2_000_000                  # searches by IMDB ID up to tt2000000
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

  def self.load_from_omdb
    query = "http://www.omdbapi.com/?i=tt"
    query << rand(MAX_ID).to_s << "&plot=short&r=json"
    result = ""
    open(query) { |f| result = f.each_line.first }
    terms = parse_omdb_data(result)
  end

  def self.parse_omdb_data(str)
    terms_array = str[2..-3].split('","')
    terms_hash = {}

    terms_array.each do |term| 
      pair = term.split('":"')
      case pair[0]
        when "Title", "Director" then terms_hash[pair[0].downcase.to_sym] = pair[1]
        when "Plot" then terms_hash[:description] = pair[1]
        when "Runtime"
          terms_hash[:runtime_in_minutes] = 
            pair[1] == "N/A" ? RUNTIME_NA : pair[1][0..-5].to_i
        when "Released" 
          terms_hash[:release_date] = 
            pair[1] == "N/A" ? REALEASE_NA : Date.strptime(pair[1], "%d %b %Y")
      end
    end

    terms_hash
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
