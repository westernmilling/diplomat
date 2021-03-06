class Interface::State < ActiveRecord::Base
  extend Enumerize

  self.table_name = 'interface_states'

  belongs_to :integration
  belongs_to :organization
  belongs_to :interfaceable, polymorphic: true

  enumerize :action, in: [:insert, :skipped, :update]
  enumerize :status, in: [:failure, :success]

  class << self
    def build_new(interfaceable, organization)
      state = Interface::State.new
      state.organization = organization
      state.integration = organization.integration
      state.interfaceable = interfaceable
      state.count = 0
      state.version = 0
      state
    end
  end

  def merge_log(log)
    self.action = log.action
    self.message = log.message
    self.status = log.status
    self.version = log.version
  end
end
