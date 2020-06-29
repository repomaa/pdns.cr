require "http/client"
require "./api/endpoints/*"

module Pdns
  class API
    BASE_PATH = "/api/v1"

    # Create a new API client
    def initialize(host_uri : URI, api_key : String)
      @client = HTTP::Client.new(host_uri, tls: host_uri.scheme == "https")
      @client.before_request do |request|
        request.headers["X-API-Key"] = api_key
      end
    end

    # Create a new API client
    def self.new(host_uri : String, api_key : String)
      new(URI.parse(host_uri), api_key)
    end

    def servers : Endpoints::Servers
      @servers ||= Endpoints::Servers.new(self)
    end

    protected def exec(method, path, type : T.class, body = nil, **query_params) : T forall T
      path = "#{BASE_PATH}#{path}".sub(%r{/$}, "")
      unless query_params.empty?
        path += "?" + HTTP::Params.build do |builder|
          query_params.each do |key, value|
            next if value.nil?
            builder.add key.to_s, value.to_s
          end
        end
      end

      puts "#{method} #{path}"
      @client.exec(method, path, body: body.try(&.to_json)) do |response|
        unless response.success?
          raise response.body_io.gets_to_end || "Something went wrong"
        end

        {% if T == Nil %}
          return
        {% elsif T == String %}
          return response.body_io.gets_to_end || raise "Empty response body"
        {% else %}
          T.from_json(response.body_io)
        {% end %}
      end
    end
  end
end
