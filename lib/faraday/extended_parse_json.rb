# encoding: utf-8
module Faraday
  # A middleware to display error messages in the JSON response
  class ExtendedParseJson < Faraday::Middleware
    def initialize(app, options = {})
      super(app)
      @options = options
    end

    def call(env)
      @app.call(env).on_complete do |response_env|
        process_response(response_env)
      end
    end

    def process_response(env)
      if env[:status] >= 400
        begin
          data = parse(env[:body]) || {}
        rescue StandardError
          data = {}
        end

        array_codes = [
          Parse::Protocol::ERROR_INTERNAL,
          Parse::Protocol::ERROR_TIMEOUT,
          Parse::Protocol::ERROR_EXCEEDED_BURST_LIMIT
        ]
        error_hash = {
          'error' => "HTTP Status #{env[:status]} Body #{env[:body]}",
          'http_status_code' => env[:status]
        }.merge(data)
        if data['code'] && array_codes.include?(data['code'])
          sleep 60 if data['code'] == Parse::Protocol::ERROR_EXCEEDED_BURST_LIMIT
          raise exception(env), error_hash.merge(data)
        elsif env[:status] >= 500
          raise exception(env), error_hash.merge(data)
        end
        raise Parse::ParseProtocolError, error_hash
      else
        data = parse(env[:body]) || {}
        env[:body] = data
      end
    end

    def exception(env)
      # NOTE: decide to retry or not, the header is deleted
      #  so it won't be sent to the server
      retries = env.request_headers.delete('X-ParseRubyClient-Retries')
      (retries.to_i.zero? ? Parse::ParseProtocolError : Parse::ParseProtocolRetry)
    end

    def parse(body)
      return nil if body.nil? || body.empty?
      JSON.parse(body)
    rescue JSON::ParserError
      nil
    end
  end
end
