# CanCanCan Role-Based Authorization System

A complete, production-ready role-based authorization system built with Ruby on Rails and CanCanCan. This demo showcases enterprise-level permission management with a beautiful, dynamic admin interface.

## 🚀 Features

### Core Authorization
- **Dynamic Permission System** - Database-driven permissions that scale automatically
- **Role-Based Access Control** - Flexible user role assignments with granular permissions
- **CanCanCan Integration** - Leverages the power of CanCanCan for Rails authorization
- **User Authentication** - Secure login/logout with Devise

### Admin Interface
- **Beautiful Grid-Based UI** - Organized permissions by model with professional styling
- **Dynamic Permission Management** - Add/edit/delete permissions with automatic UI updates
- **Role Management** - Create and configure roles with checkbox permission assignment
- **User Management** - Assign roles to users with visual feedback

### Enterprise Features
- **Audit Logging** - Complete audit trail with PaperTrail integration
- **SOC 2 / HIPAA Ready** - Built with compliance requirements in mind
- **Zero Maintenance UI** - Add new models, permissions appear automatically
- **Scalable Architecture** - Handles unlimited models and permissions

## 🛠 Tech Stack

- **Ruby on Rails 7.1.5.1**
- **CanCanCan** - Authorization framework
- **Devise** - Authentication
- **PaperTrail** - Audit logging
- **SQLite3** - Database (easily swappable)
- **Tailwind CSS** - Styling
- **Turbo** - Modern Rails interactions

## 📋 Quick Start

### Prerequisites
- Ruby 3.4.2+
- Rails 7.1+
- Bundler

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/bagus1/cancan-system.git
   cd cancan-system
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Visit the application**
   - Open http://localhost:3000
   - Login with demo credentials (see seeds file)

## 👥 Demo Users

The seed file creates these test users:

| Email | Password | Role | Permissions |
|-------|----------|------|-------------|
| admin@example.com | password | Admin | All permissions |
| editor@example.com | password | Editor | Read/Create/Update |
| viewer@example.com | password | Viewer | Read only |
| customer@example.com | password | Customer | Limited access |

## 🎯 Key Pages

### Public Access
- **/** - Home page with login
- **/users/sign_in** - Login page
- **/users/sign_up** - Registration

### Authenticated Users
- **/orders** - Order management (permissions-based access)

### Admin Only
- **/admin/roles** - Role management interface
- **/admin/ability-permissions** - Permission management with grid layout

## 🏗 System Architecture

### Models & Relationships

```
User ←→ UserRole ←→ Role ←→ RoleAbility ←→ AbilityPermission
```

- **User** - Application users with Devise authentication
- **Role** - User roles (Admin, Editor, Viewer, Customer)
- **AbilityPermission** - Individual permissions (read, create, update, destroy, etc.)
- **UserRole** - Many-to-many: Users ↔ Roles
- **RoleAbility** - Many-to-many: Roles ↔ Permissions

### Dynamic Permission System

The system automatically generates permissions for all models:

```ruby
# Auto-generated permissions (24 total)
models = %w[Order User Role AbilityPermission UserRole RoleAbility]
actions = %w[read create update destroy]
# = 6 models × 4 actions = 24 permissions
```

### CanCanCan Integration

Abilities are loaded dynamically from the database:

```ruby
class Ability
  def initialize(user)
    # Load permissions from database
    user.roles.includes(:ability_permissions).each do |role|
      role.ability_permissions.each do |permission|
        can permission.action.to_sym, permission.subject.constantize
      end
    end
  end
end
```

## 🎨 Admin Interface Features

### Grid-Based Permission Management
- **Model-Specific Sections** - Permissions organized by model
- **Visual Permission Matrix** - Easy-to-scan grid layout
- **Role Usage Indicators** - See which roles use each permission
- **One-Click Creation** - Context-aware permission creation

### Role Management
- **Permission Checkboxes** - Visual permission assignment
- **User Count Display** - See how many users have each role
- **Bulk Permission Updates** - Efficient role configuration

### URL Aesthetics
- Clean URLs with hyphens: `/admin/ability-permissions`
- Context-aware forms with pre-populated fields
- Professional styling with Tailwind CSS

## 🔧 Customization

### Adding New Models

1. **Create your model**
   ```bash
   rails generate model Product name:string price:decimal
   rails db:migrate
   ```

2. **Add to seeds** (optional)
   ```ruby
   # db/seeds.rb - Add 'Product' to models array
   models = %w[Order User Role AbilityPermission UserRole RoleAbility Product]
   ```

3. **Run seeds**
   ```bash
   rails db:seed
   ```

4. **Permissions appear automatically** in the admin interface!

### Adding Custom Actions

```ruby
# Add to controller's get_available_actions method
common_actions = %w[read create update destroy manage index show new edit process_order your_custom_action]
```

### Styling Customization

The interface uses Tailwind CSS classes. Key files:
- `app/views/layouts/application.html.erb` - Main layout
- `app/views/admin/ability_permissions/index.html.erb` - Grid interface
- `app/views/admin/roles/` - Role management views

## 🔒 Security Features

### Authentication
- Devise-based user authentication
- Secure password handling
- Session management

### Authorization
- CanCanCan-based permissions
- Database-driven access control
- Admin-only areas protected

### Audit Logging
- PaperTrail integration on all models
- Complete change tracking
- Compliance-ready audit trails

## 🚀 Production Deployment

### Environment Setup
1. **Database** - Switch to PostgreSQL for production
2. **Environment Variables** - Configure secrets and database
3. **Asset Compilation** - Precompile assets
4. **Background Jobs** - Consider Sidekiq for background processing

### Recommended Gems for Production
```ruby
# Add to Gemfile for production
gem 'pg' # PostgreSQL
gem 'redis' # Caching/sessions
gem 'sidekiq' # Background jobs
gem 'image_processing' # Image handling
```

## 🧪 Testing

The application includes comprehensive test coverage:

```bash
# Run tests
rails test

# Run with coverage
rails test:coverage
```

## 📈 Performance Considerations

- **Database Indexing** - Proper indexes on join tables
- **Eager Loading** - Includes used to prevent N+1 queries
- **Caching** - Role/permission checks cached per request

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙋‍♂️ Support

- **Issues** - Report bugs or request features via GitHub Issues
- **Documentation** - Check the `docs/` folder for additional documentation
- **Examples** - See `DEMO_INSTRUCTIONS.md` for detailed usage examples

## 🏆 Achievements

This demo showcases:
- ✅ **Enterprise Architecture** - Scalable, maintainable design
- ✅ **Modern Rails Practices** - Rails 7, Turbo, professional patterns
- ✅ **Beautiful UI/UX** - Intuitive admin interface with professional styling
- ✅ **Security Best Practices** - Proper authentication, authorization, and audit logging
- ✅ **Production Ready** - Built for real-world deployment

---

**Built with ❤️ by [Bagus](https://github.com/bagus1)**

*Perfect for technical interviews, portfolio projects, or as a foundation for production applications requiring sophisticated role-based access control.* 