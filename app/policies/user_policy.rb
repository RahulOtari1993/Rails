class UserPolicy < ApplicationPolicy
  attr_reader :organization

  def initialize(organization, user)
    @organization = organization
    super(user, record)
  end

  def index?
    organization_admin?(organization)
  end
end
