
module AuditedState
  extend ActiveSupport::Concern

  class_methods do
    def has_audited_state_through(model, valid_states=[])
      raise "AuditedState must have at least one valid state" if valid_states.empty?
      @@state_model = model
      @@valid_states = valid_states

      has_many @@state_model.to_sym, dependent: :destroy
      has_one :latest_state, lambda {  }, {class_name: @@state_model.to_s.classify}
      after_create :create_initial_state

    end
    def is_audited_state_for(model)
    end
  end

  def state
    
  end
  
  def create_initial_state
  end
end