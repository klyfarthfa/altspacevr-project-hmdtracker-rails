class Hmd < ActiveRecord::Base
  include AuditedState
  
  has_audited_state_through :hmd_states, [:announced, :devkit, :released]
end
