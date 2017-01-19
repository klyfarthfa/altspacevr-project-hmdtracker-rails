class HmdState < ActiveRecord::Base
  include AuditedState
  
  is_audited_state_for :hmd
end
