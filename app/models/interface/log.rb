class Interface::Log < ActiveRecord::Base
  extend Enumerize

  self.table_name = 'interface_logs'

  belongs_to :integration
  belongs_to :organization
  belongs_to :interfaceable, polymorphic: true

  enumerize :action, in: [:insert, :skipped, :update]
  enumerize :status, in: [:failure, :success]
end
