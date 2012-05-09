class PagesController < ApplicationController
  def about
  end
  def apply
  	    @jobs = Job.all
  end



end
