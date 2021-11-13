class ApiRequest < ApplicationRecord
  def self.log_success(exam_id)
    ApiRequest.create(status: 'success', exam_id: exam_id)
  end

  def self.log_failure(error)
    message = "#{error.class}: #{error.message}"
    ApiRequest.create(status: 'failed', message: message)
  end
end
