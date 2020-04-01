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
    organization.admins.exists?(user.id)
  end

  ##
  # @return [Boolean]
  #
  def multiple_campaigns?(organization)
    records = user.campaign_users organization

    records.count > 1
  end
end
