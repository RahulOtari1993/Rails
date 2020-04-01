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
  # Check if User is Organization admin or not
  # @return [Boolean]
  #
  def organization_admin?(organization)
    organization.admins.exists?(user.id)
  end

  ##
  # Check if User do have access on multiple campaigns of not
  # @return [Boolean]
  #
  def multiple_campaigns?(organization)
    records = user.campaign_users organization

    records.count > 1
  end
end
