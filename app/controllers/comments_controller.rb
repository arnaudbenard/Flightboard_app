class CommentsController < ApplicationController
 def create  
    @candidate = Candidate.find(params[:candidate_id])    
    @job = Job.find(params[:job_id])
    @comment = @candidate.comments.create!(params[:comment]) 
    @comment.update_attributes(author: current_user.name) 
    redirect_to job_candidate_path(@job,@candidate)
  end 

end
