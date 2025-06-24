# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    # Load abilities from database through user's roles
    if user.persisted?
      user.roles.includes(:ability_permissions).each do |role|
        role.ability_permissions.each do |permission|
          can permission.action.to_sym, permission.subject.constantize
        end
      end
    end
    
    # Add any hardcoded rules here if needed
    # Example: guests can read completed orders
    can :read, Order, status: 'completed' unless user.persisted?
    
    # Users can always read their own orders
    can :read, Order, user_id: user.id if user.persisted?
  end
end
