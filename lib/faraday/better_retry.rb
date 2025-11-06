# encoding: utf-8
module Faraday
  # Custom version of Request::Retry with two additions:
  #    1 - logs (on warn level) each retry attempt
  #    2 - stores in 'X-ParseRubyClient-Retries' header the number of
  #        remaining retries. Used in ExtendedParseJson middleware
  class BetterRetry < Faraday::Middleware
    def initialize(app, options = {})
      super(app)
      @logger = options.delete(:logger) if options.is_a?(Hash)

      default_options = {
        max: 2,
        interval: 0.05,
        max_interval: 2,
        interval_randomness: 0.5,
        backoff_factor: 2,
        exceptions: [],
        methods: [:get, :post],
        retry_statuses: [429],
        retry_block: nil
      }

      @options = OpenStruct.new(default_options.merge(options || {}))

      # NOTE: the default exceptions are lost when custom ones are given
      default_exceptions = [
        Errno::ETIMEDOUT, Timeout::Error, Faraday::TimeoutError]
      @options.exceptions.concat(default_exceptions)
    end

    def call(env)
      retries = @options.max
      retries_header(env, retries)
      request_body = env[:body]
      begin
        # after failure env[:body] is set to the response body
        env[:body] = request_body
        @app.call(env)
      rescue @errmatch => exception
        if retries > 0 && retry_request?(env, exception)
          log(env, exception)
          retries -= 1
          retries_header(env, retries)
          sleep sleep_amount(retries + 1)
          retry
        end
        raise
      end
    end

    private

    def log(env, exception)
      msg = "Retrying Parse Error #{exception.inspect} on request #{env[:url]} #{env[:body].inspect} response #{env[:response].inspect}"
      @logger.warn(msg) if @logger
    end

    def retries_header(env, retries)
      # NOTE: env is a Struct object in Faraday now and it gets
      #   instantiated ex-novo on each request so there is no way
      #   to monkey patch it, we have to use a header
      env.request_headers['X-ParseRubyClient-Retries'] = retries.to_s
    end
  end
end
