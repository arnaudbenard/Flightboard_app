class Candidate
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  include Mongo::Voteable

  field :name, :type => String
  field :resume, :type => String
  field :attached_resume
  field :visited, type: Integer, :default => 0
  has_mongoid_attached_file :cv
  field :score, :type => Integer, :default => 0 
  embeds_many :summaries
  embeds_many :comments, :inverse_of => :candidate 
  voteable self, :up => +1, :down => -1
  validates_associated :comments
  validates_presence_of :name, :resume, :cv 
  accepts_nested_attributes_for :comments, :allow_destroy => true

  belongs_to :job


  	def add_resume(submit_cv, keywords)
  		if self.attached_resume.nil? 
  			self.convert_to_txt(submit_cv)
  		end
      #Search for keywords
  		#scan_attached_resume(self)
  		
      	
  	end

    def convert_to_txt(submit_cv)
    
    require 'open-uri'
    io = open(submit_cv)
    reader = PDF::Reader.new(io)
	    reader.pages.each do |page|
	    	self.update_attributes(attached_resume: page.text)
	    end
    end

    def scan_attached_resume(candidate)
    	@keywords = Keyword.all	
    	m= TactfulTokenizer::Model.new
    	@test=m.tokenize_text(candidate.attached_resume)
    	@test.each do |test1|
    		@keywords.each do |keyword|
	            if test1.include?(keyword.name)
	            	if candidate.summaries.empty?
	               		candidate.summaries.create!(description: test1)
	               	end
                  @newscore= candidate.score + keyword.weight
                  candidate.update_attributes(score: @newscore)

	            end
        	end
     	
    	end
    end
def find_next(candidates)
      @ordered_list=candidates.order_by([[:name, :asc]])
      @list_candidate=@ordered_list.where(:name.gt => self.name)
      if @list_candidate.first.nil? == false
       @next_candidate= @list_candidate.first
      else
       @next_candidate=candidates.order_by([[:name, :asc]]).first
      end
      return @next_candidate
end


end
