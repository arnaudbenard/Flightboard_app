class Job
  include Mongoid::Document
  field :title, :type => String
  field :description, :type => String
  field :evaluated_candidate, :type => Integer, :default => 1
  has_many :candidates
  has_many :criteria

  def next_candidate(candidates,job)

    #@next_candidate=Candidate.first(:conditions => ['id > ?', self.id], :order => 'id ASC')

      
    #@next_candidate=candidates.desc(:score).limit(1).first
		
	  return @next_candidate
  end
  
  

  
  def calculate_weights(candidate)
  	  candidate.summaries.each do |summary|
  	  	@score += summary.point
  	  end
  	  return @score
  end

def calculate_mcdm(candidates,job)
  require 'extendmatrix'

    @higher = candidates.desc(:score).limit(1).first
    
    # "School" (Criteria1) + "Company" (Criteria2)
    # Pairwise matrix School = 2 * XP
    @relative=2
    @pairwise_matrix= Matrix.rows([[1, @relative], [1, (1.0/@relative)]])

    #Sum
    @sum1=@pairwise_matrix.row(0).sum
    @sum2=@pairwise_matrix.row(1).sum

    # Weights
    @weight1=@sum1/(@sum1+@sum2)
    @weight2=@sum2/(@sum1+@sum2)

    #Samples




    return @weight1
  
end


end
