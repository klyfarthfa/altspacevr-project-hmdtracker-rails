
module AuditedState
  extend ActiveSupport::Concern

  class_methods do
    def has_audited_state_through(model, valid_states=[])
      raise "AuditedState must have at least one valid state" if valid_states.empty?
      @@state_model = model
      @@valid_states = valid_states

      has_many @@state_model.to_sym, dependent: :destroy
      has_one :latest_state, lambda { order('created_at desc') }, {class_name: @@state_model.to_s.classify}

      validate do
        errors.add(:state, "must be #{@@valid_states} (is #{self.state})") unless @@valid_states.include?(self.state)
      end

      after_save do
        state_klass = @@state_model.to_s.classify.constantize
        if @dirty_state.nil? && latest_state.nil? #should happen iff this is a new model and state has not been modified
          state_klass.create(hmd_id: self.id, state: @@valid_states.first)
        elsif @dirty_state.present? && (latest_state.nil? || @dirty_state.to_sym != latest_state.state.to_sym)
          state_klass.create(hmd_id: self.id, state: @dirty_state)
        end
        @dirty_state = nil
        @state_update = false
      end

      define_method("state") do
        (@dirty_state || (latest_state ? latest_state.state : @@valid_states.first)).to_sym
      end

      define_method("state=") do |val|
        @state_updated = true unless val == self.state
        @dirty_state = val
      end

      #redefine reload to allow us to clear dirty state
      define_method("reload") do |options = nil|
        result = super(options)
        @dirty_state = nil
        @state_update = false
        result
      end

    end
    def is_audited_state_for(model)
      @@stated_model = model
      belongs_to @@stated_model.to_sym

    end
  end
  
end