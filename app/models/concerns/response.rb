# frozen_string_literal: true

module Response
  def json_response(messages:, data:, status:)
    render json: {
      messages: messages,
      data: data
    }, status: map_status(status)
  end

  def map_status(status)
    return :ok if status

    :unprocessable_entity
  end
end
