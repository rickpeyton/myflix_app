class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    if object.average_rating > 0
      "Rating: #{object.average_rating}/5.0"
    else
      "Rating: Not Yet Rated"
    end
  end
end
