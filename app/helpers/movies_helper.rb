module MoviesHelper
  def format_date(date)
    date.strftime("%b %d, %Y")
  end
end
