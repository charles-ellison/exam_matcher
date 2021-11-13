class User < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :validate_phone_number
  has_many :user_exams
  has_many :exams, through: :user_exams

  def self.find_or_create_user(user_params)
    user = User.find_by(user_params)
    return user if user.present?
    
    user = User.create!(user_params)


    
    # if user.save
    #   user
    # else
    #   raise ActionController::BadRequest.new('Invalid exam parameters')
    # end
  end

  private

  def validate_phone_number
    errors.add(:phone_number, 'Validation failed: phone number cannot be blank') if phone_number.blank?
    errors.add(:phone_number, 'Validation failed: phone number must be ten characters long') unless phone_number.to_s.size == 10
    
    valid_chars = '0'..'9'
    unless phone_number.to_s.chars.all? { |char| valid_chars.include?(char) }
      errors.add(:phone_number, 'Validation failed: phone number must only contain numeric values')
    end
  end
end
