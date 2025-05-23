module Requests
  module ResponseHelpers
    def expect_status(code)
      expect(response).to have_http_status(code)
    end

    def expect_error_message(message)
      expect(parsed_response['errors']).to include(message)
    end
  end
end
