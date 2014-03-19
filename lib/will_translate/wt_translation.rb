class WtTranslation < ActiveRecord::Base
  
  belongs_to  :translateable, :polymorphic => true
  
end