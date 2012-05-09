class Criterium
  include Mongoid::Document
  belongs_to :job
  
  field :name, :type => String
  field :description, :type => String
  field :weight, :type => Integer, :default => 1
end
