class Keyword
  include Mongoid::Document
  field :name, :type => String
  field :weight, :type => Integer
  field :type, :type => String
  field :domain, :type => String
  
  def self.grab_keywords(number)
  	@fake_resume = "Fake resume "
  	@random = Keyword.all.shuffle.slice(0, number)
  	number.times do |i|
  		puts "Cat:" << @random[i].name 
  		@fake_resume << @random[i].name << " .\n"
  	end
  	return @fake_resume
  end

end
