class Otp < ActiveRecord::Base
  attr_accessible :phone_number, :service, :generated_at

  validates :phone_number, presence: true
  validates :service, presence: true
  validates :generated_at, presence: true
end
