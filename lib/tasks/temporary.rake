namespace :temporary do
  desc 'do python script'
  task :python=> :environment do
    company=SelectedCompany.last
    system("python3 #{Rails.root}/scripts/python_stockAnalize/japan_sock.py #{company.code} #{company.days} #{company.runs}")
  end
end
