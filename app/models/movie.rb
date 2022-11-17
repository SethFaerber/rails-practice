class Movie < ApplicationRecord

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
