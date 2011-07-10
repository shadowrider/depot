class Product < ActiveRecord::Base
  default_scope :order => 'title'
  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates_format_of :image_url, :with => %r{\.(gif|png|jpg)$}i, :message => 'Must be a URL to GIF, PNG or JPG picture'
  validates_size_of :title, :minimum => 10, :message => 'Must be longer than 10 characters'
end
