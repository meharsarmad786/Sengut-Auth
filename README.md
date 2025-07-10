# Sengut Auth - Custom Authentication & Access Control System

A comprehensive Ruby on Rails application implementing **organization-based access control** and **age-based participation rules** with parental consent management and analytics reporting.

## 🏗️ Architecture Overview

This system provides a sophisticated authentication and authorization solution designed for organizations that need to manage user access based on both organizational membership and age-appropriate participation rules.

### Key Features

1. **Organization-Based Access Control**
   - Multi-level role-based permissions (Admin, Moderator, Member)
   - Organization-specific participation rules
   - Membership verification and management
   - Organization analytics and reporting

2. **Age-Based Participation Rules**
   - Automatic age verification during registration
   - Age-group specific participation spaces
   - Age-appropriate content filtering
   - Parental consent workflow for minors

3. **Security & Compliance**
   - Secure authentication with Devise
   - Comprehensive authorization with CanCanCan
   - Activity tracking and audit logs
   - GDPR-compliant data handling

4. **Analytics & Reporting**
   - Organization participation metrics
   - User engagement analytics
   - Age demographic reporting
   - Activity dashboards with charts

## 🛠️ Technology Stack

- **Backend**: Ruby on Rails 7.2
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Authorization**: CanCanCan
- **Role Management**: Rolify
- **UI Framework**: Bootstrap 5
- **Charts**: Chartkick with Groupdate
- **File Processing**: Active Storage with image_processing
- **Testing**: RSpec, FactoryBot, Faker

## 📋 Prerequisites

- Ruby 3.1.2 or higher
- PostgreSQL 12+
- Node.js 16+ (for asset compilation)
- Yarn package manager

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd sengut_auth
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Install JavaScript packages
yarn install
```

### 3. Database Setup
```bash
# Configure database
cp config/database.yml.example config/database.yml
# Edit database.yml with your PostgreSQL credentials

# Create and setup database
rails db:create
rails db:migrate
rails db:seed
```

### 4. Environment Configuration
```bash
# Generate master key (if not present)
rails credentials:edit

# Set environment variables (optional)
export RAILS_ENV=development
```

### 5. Start the Application
```bash
# Start the development server
rails server

# Or use foreman for full asset pipeline
bin/dev
```

The application will be available at `http://localhost:3000`

## 👥 User Roles & Permissions

### Organization Roles

#### Admin
- **Full Management**: Create, edit, and delete organizations
- **Member Management**: Add/remove members, assign roles
- **Analytics Access**: View comprehensive organization statistics
- **Content Moderation**: Manage all organization content

#### Moderator
- **Content Management**: Moderate posts and activities
- **Member Oversight**: View member activities and statistics
- **Limited Admin**: Some administrative functions
- **Analytics Access**: View organization analytics

#### Member
- **Basic Participation**: Join discussions and activities
- **Personal Data**: Manage own profile and activities
- **View Access**: See organization content and members
- **Limited Actions**: Create content within organization

### Age-Based Access Levels

#### Children (6-12 years)
- **Parental Consent Required**: Must have verified parental consent
- **Content Filtering**: Only age-appropriate content
- **Supervised Activities**: Limited participation options
- **Privacy Protection**: Enhanced privacy controls

#### Teenagers (13-17 years)
- **Parental Consent Required**: Must have verified parental consent
- **Teen Content Access**: Access to teen-appropriate content
- **Moderate Participation**: Most activities available
- **Guided Experience**: Some restrictions apply

#### Adults (18+ years)
- **Full Access**: All content and activities
- **Organization Creation**: Can create and manage organizations
- **Complete Autonomy**: No participation restrictions
- **Admin Capabilities**: Eligible for all roles

## 🔐 Security Features

### Authentication
- **Secure Registration**: Email verification and validation
- **Strong Passwords**: Enforced password complexity
- **Session Management**: Secure session handling
- **Account Recovery**: Secure password reset process

### Authorization
- **Role-Based Access**: Fine-grained permission system
- **Resource Protection**: Controller-level authorization
- **Age Verification**: Automatic age-based restrictions
- **Consent Management**: Parental consent tracking

### Activity Tracking
- **Audit Logs**: All user activities logged
- **Security Monitoring**: Login/logout tracking
- **Compliance Reporting**: GDPR-compliant data handling
- **Analytics Integration**: Activity data for insights

## 📊 Analytics & Reporting

### Organization Analytics
- **Member Statistics**: Total members, demographics
- **Activity Metrics**: Participation rates, engagement
- **Growth Tracking**: Membership growth over time
- **Role Distribution**: Admin/Moderator/Member ratios

### User Analytics
- **Participation History**: Personal activity timeline
- **Organization Membership**: All memberships and roles
- **Age Group Insights**: Age-appropriate participation
- **Consent Status**: Parental consent tracking

### System Analytics
- **Platform Usage**: Overall system utilization
- **Age Demographics**: User age distribution
- **Organization Health**: Active vs inactive organizations
- **Consent Compliance**: Parental consent statistics

## 🏢 Organization Management

### Creating Organizations
1. **Admin Registration**: Create account or login
2. **Organization Setup**: Fill in organization details
3. **Member Invitation**: Add initial members
4. **Role Assignment**: Assign admin/moderator roles
5. **Activation**: Activate organization for public joining

### Managing Members
- **Role Assignment**: Promote/demote members
- **Access Control**: Grant/revoke permissions
- **Activity Monitoring**: Track member participation
- **Bulk Operations**: Manage multiple members

### Organization Settings
- **Profile Management**: Update organization details
- **Privacy Settings**: Control visibility and joining
- **Content Moderation**: Set participation rules
- **Analytics Configuration**: Configure reporting

## 👨‍👩‍👧‍👦 Parental Consent System

### For Minor Users
1. **Age Verification**: Automatic age detection from DOB
2. **Consent Requirement**: System blocks participation without consent
3. **Parent Notification**: Email sent to parent/guardian
4. **Consent Form**: Secure form completion
5. **Verification**: Email confirmation from parent

### For Parents/Guardians
1. **Consent Request**: Receive email notification
2. **Child Verification**: Confirm child's identity
3. **Permission Granting**: Complete consent form
4. **Ongoing Monitoring**: Receive participation updates
5. **Consent Management**: Update or revoke consent

### Compliance Features
- **Legal Compliance**: COPPA and GDPR compliant
- **Audit Trail**: Complete consent history
- **Expiration Handling**: Automatic consent renewal
- **Privacy Protection**: Enhanced minor privacy controls

## 🧪 Testing

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/

# Run with coverage
bundle exec rspec --format documentation
```

### Test Structure
- **Model Tests**: User, Organization, Permissions
- **Controller Tests**: Authentication, Authorization
- **Integration Tests**: Full user workflows
- **System Tests**: End-to-end scenarios

## 📱 API Documentation

### Authentication Endpoints
```ruby
POST /users/sign_in        # User login
POST /users/sign_up        # User registration
DELETE /users/sign_out     # User logout
GET /users/edit            # Edit profile
```

### Organization Endpoints
```ruby
GET /organizations         # List organizations
POST /organizations        # Create organization
GET /organizations/:id     # Show organization
PUT /organizations/:id     # Update organization
DELETE /organizations/:id  # Delete organization
POST /organizations/:id/join    # Join organization
DELETE /organizations/:id/leave # Leave organization
GET /organizations/:id/analytics # Organization analytics
```

### Parental Consent Endpoints
```ruby
GET /parental_consents/new     # New consent form
POST /parental_consents        # Create consent
GET /parental_consents/:id     # Show consent
PUT /parental_consents/:id     # Update consent
DELETE /parental_consents/:id  # Delete consent
```

## 🎨 UI/UX Features

### Responsive Design
- **Mobile-First**: Optimized for all devices
- **Bootstrap 5**: Modern, accessible UI components
- **Icons**: Bootstrap Icons for clear visual cues
- **Animations**: Smooth transitions and interactions

### User Experience
- **Intuitive Navigation**: Clear menu structure
- **Visual Feedback**: Success/error messages
- **Age Indicators**: Clear age-based visual cues
- **Accessibility**: WCAG compliant design

### Dashboard Features
- **Personal Dashboard**: User-specific overview
- **Organization Views**: Role-based information
- **Analytics Charts**: Visual data representation
- **Activity Feeds**: Real-time updates

## 🔧 Configuration

### Environment Variables
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost/db_name

# Email (for parental consent)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# Application
SECRET_KEY_BASE=your_secret_key
```

### Application Settings
```ruby
# config/application.rb
config.time_zone = 'UTC'
config.active_record.default_timezone = :utc

# Age-based settings
config.minor_age_threshold = 18
config.consent_expiry_period = 2.years
```

## 🚦 Deployment

### Production Setup
```bash
# Environment
export RAILS_ENV=production

# Database
rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production
rails db:seed RAILS_ENV=production

# Assets
rails assets:precompile
```

### Docker Deployment
```dockerfile
FROM ruby:3.1.2
WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

## 📈 Performance Optimization

### Database Optimization
- **Indexes**: Optimized queries with proper indexing
- **N+1 Prevention**: Includes and joins for efficient queries
- **Pagination**: Kaminari for large datasets
- **Caching**: Redis for session and fragment caching

### Asset Optimization
- **CSS/JS Minification**: Production asset compilation
- **Image Processing**: Optimized image handling
- **CDN Integration**: Asset delivery optimization
- **Lazy Loading**: Efficient content loading

## 🔍 Monitoring & Maintenance

### Health Checks
- **Application Health**: Built-in health check endpoint
- **Database Health**: Connection and query monitoring
- **External Services**: Email service monitoring
- **Performance Metrics**: Response time tracking

### Logging & Debugging
- **Structured Logging**: JSON-formatted logs
- **Error Tracking**: Comprehensive error handling
- **Performance Monitoring**: Query and response analysis
- **Security Auditing**: Access and permission logs

## 📚 Sample Data

The application comes with comprehensive seed data including:

### Sample Users
- **Admin User**: admin@sengut.com / password123
- **Adult User**: adult@sengut.com / password123
- **Teen User**: teen@sengut.com / password123 (with parental consent)
- **Child User**: child@sengut.com / password123 (with parental consent)
- **Senior User**: senior@sengut.com / password123

### Sample Organizations
- **Tech Innovation Club**: Technology community
- **Green Earth Initiative**: Environmental organization
- **Youth Leadership Program**: Youth development
- **Senior Community Center**: Senior services
- **Creative Arts Collective**: Arts community

### Age Groups
- **Children (6-12)**: Parental consent required
- **Teenagers (13-17)**: Parental consent required
- **Young Adults (18-25)**: Full access
- **Adults (26-64)**: Full access
- **Seniors (65+)**: Full access

## 🤝 Contributing

### Development Guidelines
1. **Code Style**: Follow Rails conventions
2. **Testing**: Write comprehensive tests
3. **Documentation**: Update README for changes
4. **Security**: Follow security best practices
5. **Performance**: Optimize database queries

### Pull Request Process
1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit pull request with clear description

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 🆘 Support

For support, please:
1. Check the documentation
2. Search existing issues
3. Create a new issue with detailed description
4. Contact the development team

## 📊 Demo Features

### Organization-Based Access Control Demo
1. **Login as Admin**: admin@sengut.com / password123
2. **View Analytics**: Access organization statistics
3. **Manage Members**: Add/remove users, assign roles
4. **Content Moderation**: Moderate organization content

### Age-Based Participation Demo
1. **Teen User**: teen@sengut.com / password123
2. **Child User**: child@sengut.com / password123
3. **Parental Consent**: View consent requirements
4. **Age-Appropriate Content**: See filtered content

### Analytics & Reporting Demo
1. **Organization Analytics**: View participation metrics
2. **User Statistics**: See demographic breakdowns
3. **Activity Tracking**: Monitor user engagement
4. **Consent Compliance**: Track parental consent status

---

**Built with ❤️ for secure, age-appropriate, and well-organized community participation.**
