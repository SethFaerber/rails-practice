class Movie < ApplicationRecord
  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations


  # This says 'has_many' is a method, and it is being passed a parameter of the symbol 'reviews'
  # has_many :reviews

  # This says 'has_many' is a key and the value is 'reviews'
  # has_many: reviews

  RATINGS = %w(G PG PG-13 R)

  validates :title, presence: true, uniqueness: true
  validates :rating, inclusion: { in: RATINGS }
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  # Lambdas
  scope :released, -> { where("released_on < ?", Time.now).order("released_on desc") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, ->(max=5) { released.limit(max) }
  scope :nineties, -> { where(released_on: "1990-01-01".."1999-12-31") }

  def self.from_nineties
    # puts where("released_on BETWEEN ? AND ?", "1991-01-01", "1999-12-31")
    # puts where("released_on BETWEEN '1990-01-01' AND '1999-12-31'")
    where(released_on: "1990-01-01".."1999-12-31")

    # TODO: What is going on with these two syntaxes?
    # puts where(:created_at => @selected_date.beginning_of_day..@selected_date.end_of_day)
    # puts where('created_at BETWEEN ? AND ?', @selected_date.beginning_of_day, @selected_date.end_of_day)

  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_review
    average = reviews.average(:stars)

    average ? average * 20 : 0
  end

  def flop?
    total_gross.blank? || total_gross < 225000000
  end

  def to_param
    slug
  end

private

  def set_slug
    self.slug = title.parameterize
  end


end




hash_on_fire = Hash(:evacuee => "Seth")
safe_new_hash = Hash(:evacuee_on_fire => "Melvin")
safe_new_hash[:evacuee_on_fire] = hash_on_fire.delete :evacuee
safe_new_hash
#=> {:evacuee_on_fire=>"Seth"}