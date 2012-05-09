# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'admin', :email => 'admin@flightboard.ch', :password => 'password', :password_confirmation => 'password'
puts 'New user created: ' << user.name

require 'csv'    

puts 'ADDING KEYWORDS'
csv_text = File.read('db/seeds/keywords.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  row = row.to_hash.with_indifferent_access
  Keyword.create!(row.to_hash.symbolize_keys)
end
puts 'done.'
puts 'ADDING JOBS, CANDIDATES AND CRITERIA'

3.times do |s|
	job = Job.create! :title => Faker::Company.name, :description => Faker::Company.bs
	puts 'New job created: ' << job.title
	3.times do |t|
		job.candidates.create! :name => Faker::Name.name, :attached_resume => Keyword.grab_keywords(3)
		job.candidates.each do |candidate|
			Candidate.scan_attached_resume(candidate)
		end
		job.criteria.create! :name => Faker::Name.name, :description => Faker::Company.bs
	end
end