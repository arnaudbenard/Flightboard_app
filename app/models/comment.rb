class Comment
  include Mongoid::Document


  field :content
  field :author


  embedded_in :candidate, :inverse_of => :comments
end
