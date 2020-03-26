class ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  ##
  # @return [Boolean]
  #
  def organization_admin?(organization)
    @_organization_admin ||= Hash.new do |hash, key|
      hash[key] = organization.admins.exists?(user.id)
    end

    binding.pry

    @_organization_admin[organization]
  end
end
