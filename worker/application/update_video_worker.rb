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
      @queue.videos do |video|
        http_response = HTTP.put("#{@config.API_HOST}/api/v1/add/#{video}")
        @update_trips.append(code) if http_response.status.success?
        puts "Update Video: #{code} failed" unless http_response.status.success?
      end
      @update_trips
    end
  end
end