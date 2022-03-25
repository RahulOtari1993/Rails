class MyjobJob < ApplicationJob
  queue_as :default

  def perform(*args)
  puts "HELLO EXAMPLE OF BACKGROUND JOB"
  end
end
