class Movie < ApplicationRecord

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :rating, inclusion: { in: RATINGS }
  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  def self.released
    where("released_on < ?", Time.now).order("released_on desc")
  end

  def self.from_nineties
    # where("released_on BETWEEN ? AND ?", "1990-01-01", "1999-12-31")
    # where("released_on BETWEEN '1990-01-01' AND '1999-12-31'")
    where(released_on: "1990-01-01".."1999-12-31")
  end

  def flop?
    total_gross.blank? || total_gross < 225000000
  end
end
