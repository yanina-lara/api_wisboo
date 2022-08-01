class Product < ApplicationRecord
  scope :filter_currency, -> (currency) { where currency: currency }
  scope :filter_query, lambda{ |name| self.where("name LIKE ?", "%#{name}%") if name.present? }
end
