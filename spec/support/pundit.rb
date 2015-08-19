module PunditHelpers
  def raise_pundit_error(policy_class)
    raise Pundit::NotAuthorizedError.new policy: policy_class
  end
end

RSpec.configure do |config|
  config.include PunditHelpers, type: :controller
end
