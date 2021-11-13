class User < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name
  validate :validate_phone_number
  has_many :user_exams
  has_many :exams, through: :user_exams

  VALID_PHONE_CHARS = '0'..'9'

  private

  def validate_phone_number
    errors.add(:phone_number, 'cannot be blank') if phone_number.blank?
    errors.add(:phone_number, 'must be ten characters long') unless phone_number.to_s.size == 10

    unless phone_number.to_s.chars.all? { |char| VALID_PHONE_CHARS.include?(char) }
      errors.add(:phone_number, 'must only contain numeric values')
    end
  end
end
