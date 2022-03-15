namespace :sample do
  desc "TODO"
  task test: :environment do
  end

  desc 'saying hi to cron'    
    task :test => [ :environment ] do      
      puts 'hi cron :)'  
    end
end
