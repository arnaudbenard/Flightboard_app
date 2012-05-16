class CandidatesController < ApplicationController

  # GET /candidates
  # GET /candidates.json
  def index
    #@candidates = Candidate.all
    @job = Job.find(params[:job_id])
    @candidates = @job.candidates.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidates }
    end
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
    require 'open-uri'

    @summaries=Summary.all
    @candidate = Candidate.find(params[:id])
    @keywords= Keyword.all
    @candidates = Candidate.all
    @job = Job.find(params[:job_id])
    @comment = @candidate.comments.create!(params[:comment])  

    @next_candidate=@candidate.find_next(@job.candidates)

  

    if @candidate.cv.nil? == false
    	@candidate.add_resume(@candidate.cv.path,@keywords)
    end

    @job = Job.find(params[:job_id]) 
    @keywords= Keyword.all
    @summaries= @candidate.summaries.all
  end

  # GET /candidates/new
  # GET /candidates/new.json
  def new
    @candidate = Candidate.new
    @job = Job.find(params[:job_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @candidate }
    end
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.find(params[:id])
  end

  # POST /candidates
  # POST /candidates.json
  def create
    @job = Job.find(params[:job_id])
    @candidate = @job.candidates.build(params[:candidate])
    respond_to do |format|
      if @candidate.save
        format.html { redirect_to(job_candidate_path(@job.id,@candidate.id), :notice => 'Time to organise your resume') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { redirect_to(new_job_candidate_path(@job), :notice => 
        'Candidate could not be saved. Please fill in all fields')}
        format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /candidates/1
  # PUT /candidates/1.json
  def update
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to candidates_url }
      format.json { head :no_content }
    end
  end
  
  def vote_up
    @candidate = Candidate.find(params[:id])
    @job = Job.find(params[:job_id])
    current_user.vote(@candidate, :up) 
    redirect_to job_candidate_path(@job.id,@candidate.id), :notice => "You have approved #{@candidate.name} as a suitable candidate"
  end
  
  def vote_down
    @candidate = Candidate.find(params[:id])
    @job = Job.find(params[:job_id])
    current_user.vote(@candidate, :down) 
    redirect_to job_candidate_path(@job.id,@candidate.id), :notice => "You have disapproved #{@candidate.name} as a suitable candidate"
  end

end
