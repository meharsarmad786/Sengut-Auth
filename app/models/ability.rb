# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      # Authenticated user abilities
      can :read, User, id: user.id
      can :update, User, id: user.id
      can :destroy, User, id: user.id

      # Organization abilities based on membership
      user.organizations.each do |organization|
        membership = user.organization_memberships.find_by(organization: organization)
        
        case membership&.role
        when 'admin'
          # Admin can manage everything in their organization
          can :manage, Organization, id: organization.id
          can :manage, OrganizationMembership, organization_id: organization.id
          can :read, User, organization_memberships: { organization_id: organization.id }
          can :manage, ParticipationActivity, organization_id: organization.id
          can :read, :analytics, organization_id: organization.id
          
        when 'moderator'
          # Moderators can read and moderate content
          can :read, Organization, id: organization.id
          can :read, OrganizationMembership, organization_id: organization.id
          can :read, User, organization_memberships: { organization_id: organization.id }
          can :manage, ParticipationActivity, organization_id: organization.id
          can :read, :analytics, organization_id: organization.id
          
        when 'member'
          # Members can read and participate
          can :read, Organization, id: organization.id
          can :read, OrganizationMembership, organization_id: organization.id, user_id: user.id
          can :create, ParticipationActivity, organization_id: organization.id, user_id: user.id
          can :read, ParticipationActivity, organization_id: organization.id, user_id: user.id
        end
      end

      # Age-based participation rules
      if user.minor?
        # Minors need parental consent for participation
        if user.can_participate_without_consent?
          can :participate, :age_appropriate_content
        else
          cannot :participate, :anything
          can :request, :parental_consent
        end
      else
        # Adults can participate in all content
        can :participate, :all_content
      end

      # Parental consent management
      if user.minor?
        can :create, ParentalConsent, user_id: user.id
        can :read, ParentalConsent, user_id: user.id
        can :update, ParentalConsent, user_id: user.id
      end

      # Organization joining abilities
      can :join, Organization do |organization|
        organization.active? && !user.member_of?(organization)
      end

      # Age group access
      can :read, AgeGroup do |age_group|
        user.age_group == age_group
      end

    else
      # Guest user abilities
      can :read, Organization, active: true
      can :create, User
      can :read, AgeGroup
    end

    # Additional age-based restrictions
    define_age_based_abilities(user)
  end

  private

  def define_age_based_abilities(user)
    return unless user.persisted?

    case user.age
    when 0..12
      # Children (0-12) - Restricted access
      can :access, :kids_content
      cannot :access, :teen_content
      cannot :access, :adult_content
      
    when 13..17
      # Teenagers (13-17) - Moderate access
      can :access, :kids_content
      can :access, :teen_content
      cannot :access, :adult_content
      
    when 18..Float::INFINITY
      # Adults (18+) - Full access
      can :access, :kids_content
      can :access, :teen_content
      can :access, :adult_content
    end
  end
end
