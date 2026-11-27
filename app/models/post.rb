class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  def self.search(keyword)
    return all if keyword.blank?

    pattern = "%#{sanitize_sql_like(keyword, "!")}%"

    where(
      "title LIKE :pattern ESCAPE '!' OR body LIKE :pattern ESCAPE '!'",
      pattern: pattern
    )
  end
end
