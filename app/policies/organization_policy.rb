class OrganizationPolicy < ApplicationPolicy
  attr_reader :organization

  def initialize(user, organization)
    @organization = organization
    super(user, record)
  end

  def list_admins?
    organization_admin?(organization)
  end
end
