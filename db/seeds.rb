# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Clearing existing data..."
UserRole.destroy_all
RoleAbility.destroy_all
User.destroy_all
Role.destroy_all
AbilityPermission.destroy_all
Order.destroy_all

puts "Creating permissions..."

# Create base abilities for all models
models = %w[Order User Role AbilityPermission UserRole RoleAbility]
actions = %w[read create update destroy]

models.each do |model|
  actions.each do |action|
    AbilityPermission.find_or_create_by(
      action: action,
      subject: model,
      description: "#{action.capitalize} #{model.pluralize.downcase}"
    )
  end
end

puts "Created #{AbilityPermission.count} permissions"

puts "Creating roles..."

# Create default roles
admin_role = Role.create!(
  name: 'Admin',
  description: 'Full system access - can manage everything'
)

editor_role = Role.create!(
  name: 'Editor',
  description: 'Can read, create, and update orders and users'
)

viewer_role = Role.create!(
  name: 'Viewer',
  description: 'Read-only access to orders and basic user info'
)

customer_role = Role.create!(
  name: 'Customer',
  description: 'Can manage their own orders only'
)

puts "Created #{Role.count} roles"

puts "Assigning permissions to roles..."

# Admin gets everything
admin_role.ability_permissions = AbilityPermission.all

# Editor gets read/create/update for Orders and limited User access
editor_abilities = AbilityPermission.where(
  action: ['read', 'create', 'update'],
  subject: ['Order']
) + AbilityPermission.where(action: 'read', subject: ['User', 'Role', 'AbilityPermission'])
editor_role.ability_permissions = editor_abilities

# Viewer gets read-only access to orders and users
viewer_abilities = AbilityPermission.where(
  action: 'read',
  subject: ['Order', 'User']
)
viewer_role.ability_permissions = viewer_abilities

# Customer gets read/create/update for their own orders only (this will be handled in Ability class)
customer_abilities = AbilityPermission.where(
  action: ['read', 'create', 'update'],
  subject: ['Order']
)
customer_role.ability_permissions = customer_abilities

puts "Creating users..."

# Create sample users
admin_user = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
admin_user.roles << admin_role

editor_user = User.create!(
  email: 'editor@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
editor_user.roles << editor_role

viewer_user = User.create!(
  email: 'viewer@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
viewer_user.roles << viewer_role

customer_user = User.create!(
  email: 'customer@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
customer_user.roles << customer_role

puts "Created #{User.count} users"

puts "Creating sample orders..."

# Create sample orders
[admin_user, editor_user, customer_user].each_with_index do |user, index|
  3.times do |i|
    Order.create!(
      user: user,
      total: (50 + (index * 25) + (i * 10)).to_f,
      status: ['pending', 'processing', 'completed'].sample
    )
  end
end

puts "Created #{Order.count} orders"

puts "\n" + "="*50
puts "AUTHORIZATION SYSTEM SETUP COMPLETE!"
puts "="*50

puts "\nUser Accounts Created:"
puts "Admin:    admin@example.com    / password123"
puts "Editor:   editor@example.com   / password123"
puts "Viewer:   viewer@example.com   / password123"
puts "Customer: customer@example.com / password123"

puts "\nRole Permissions Summary:"
puts "Admin:    Can manage everything"
puts "Editor:   Can read/create/update Orders, read Users/Roles"
puts "Viewer:   Can read Orders and Users only"
puts "Customer: Can manage their own Orders only"

puts "\nDatabase Summary:"
puts "Users: #{User.count}"
puts "Roles: #{Role.count}"
puts "Permissions: #{AbilityPermission.count}"
puts "Orders: #{Order.count}"
puts "User-Role assignments: #{UserRole.count}"
puts "Role-Permission assignments: #{RoleAbility.count}"

puts "\nNext steps:"
puts "1. Start the Rails server: rails server"
puts "2. Visit the admin interface to manage roles and permissions"
puts "3. Test authorization with different user accounts"
