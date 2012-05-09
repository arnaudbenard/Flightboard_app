class Summary
  include Mongoid::Document
  field :description
  field :point, :type => Integer, :default => 0 
  field :priority, :type => Integer, :default => 0 
  field :type
  embedded_in :candidate

end
