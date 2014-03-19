# Internal model used to store localised content. This has a polymorphic relationship (+:translateable+) with the models
# you are localising.
class WtTranslation < ActiveRecord::Base
  
  belongs_to  :translateable, :polymorphic => true
  
end