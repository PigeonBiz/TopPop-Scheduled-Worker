# frozen_string_literal: true

require_relative '../../init'
require 'aws-sdk-sqs'
require 'http'

module TopPop
  # Setup config environment
  class UpdateVideoWorker
    def initialize
      @config = UpdateVideoWorker.config
      @queue = TopPop::Messaging::Queue.new(
        @config.UPDATE_QUEUE_URL, @config
      )
    end

    def call
      puts "Update DateTime: #{Time.now}"

      # Update everyday videos
      update_trips
    end

    def update_trips
      @update_trips = []
      @queue.poll do |code|
        puts code
        unless @update_trips.include? code
          http_response = HTTP.put("#{@config.API_HOST}/api/trips/#{code}/update")
          @update_trips.append(code) if http_response.status.success?
          puts "Update TripQuery: #{code} failed" unless http_response.status.success?
        end
      end
      @update_trips
    end
  end
end