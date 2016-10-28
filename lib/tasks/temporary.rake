namespace :temporary do
  desc 'do python script'
  task :python => :environment do
    system("python3 #{Rails.root}/scripts/python_stockAnalize/japan_sock.py 7203 365 1000")
  end
end
