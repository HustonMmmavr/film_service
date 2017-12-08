class Film < ApplicationRecord
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  validates :title,
  :presence => {:message => "Title can't be empty." }

  validates :about,
  :presence => {:message => "About can't be empty." }

  # validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  validates :director,
  :presence => {:message => "Director can't be empty." }

  validates :year,
  :presence => {:message => "Year can't be empty." }, numericality: { only_integer: true }

  validates :length, numericality: { only_integer: true }

  validates :rating,
  :presence => {:message => "Rating can't be empty." }, numericality: true
end
