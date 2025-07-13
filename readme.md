# TechForing Project Management API

A Django REST Framework-based project management system that provides comprehensive APIs for managing projects, tasks, team members, and comments.

## Features

- **User Management**: Custom user authentication with JWT tokens
- **Project Management**: Create and manage projects with ownership
- **Team Collaboration**: Add team members to projects with role-based access
- **Task Management**: Create, assign, and track tasks with status and priority
- **Comments System**: Add comments to tasks for better communication
- **API Documentation**: Interactive Swagger/ReDoc documentation

## Technology Stack

- **Backend**: Django 5.2.4, Django REST Framework
- **Authentication**: JWT (JSON Web Tokens) with SimpleJWT
- **Database**: SQLite (development)
- **API Documentation**: drf-yasg (Swagger/OpenAPI)
- **Admin Interface**: Django Jazzmin theme

## Installation

### Quick Setup (Recommended)

**For Linux/macOS users**, for a fast, automated setup, simply run:

```bash
bash setup.sh
```

**For Windows users**: The bash script may not work directly. Please follow the [Manual Installation](#manual-installation) steps below.

This single command will:
- Create virtual environment
- Install all dependencies
- Set up database and run migrations
- Create default superuser
- Start the development server

**Default Superuser Credentials:**
- Username: `admin`
- Password: `admin123`
- Email: `admin@techforing.com`

The server will start automatically at `http://localhost:8000/` with all credentials displayed in the terminal.

### Manual Installation

If you prefer manual setup or are using Windows:

1. **Clone and navigate to the project**:
   ```bash
   cd /path/to/techforing_test
   ```

2. **Activate virtual environment** (linux base OS):
   ```bash
   source env/bin/activate
   ```
   For windows
   ```bash
   env\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Run migrations**:
   ```bash
   python manage.py migrate
   ```

5. **Create superuser** (optional):
   ```bash
   python manage.py createsuperuser
   ```

6. **Start development server**:
   ```bash
   python manage.py runserver
   ```

## Quick API Testing with Postman

**For quick API testing, we highly recommend using the provided Postman collection instead of reading through all the documentation below.**

A complete Postman collection is available in the `postman_doc/` folder:
- **File**: `TechForing Project Management API.postman_collection.json`
- **Import**: Simply import this file into Postman
- **Ready to use**: All endpoints are pre-configured with proper structure
- **Authentication**: JWT token handling is already set up

**To get started:**
1. Run `bash setup.sh` to start the project
2. Import the Postman collection from `postman_doc/` folder
3. Use the default credentials: `admin` / `admin123`
4. Start testing APIs immediately

### Alternative: Swagger UI

You can also test APIs directly in your browser using Swagger UI:
- **URL**: `http://127.0.0.1:8000/swagger/`
- **Interactive**: Test endpoints directly from the browser
- **Authentication**: Use the "Authorize" button to add JWT token
- **No setup required**: Ready to use once the server is running

The detailed documentation below is mainly for reference and advanced configuration.

## API Endpoints

### Authentication
- `POST /auth/login/` - Obtain JWT tokens
- `POST /auth/login/refresh/` - Refresh access token

### Project Management
- `GET /pr/projects/` - List all projects
- `POST /pr/projects/` - Create new project
- `GET /pr/projects/{id}/` - Get project details
- `PUT /pr/projects/{id}/` - Update project
- `DELETE /pr/projects/{id}/` - Delete project

### User Management
- `GET /pr/users/` - List users (admin only)
- `POST /pr/users/` - Create new user
- `GET /pr/users/{id}/` - Get user details

### Task Management
- `GET /pr/tasks/` - List all tasks
- `POST /pr/tasks/` - Create new task
- `GET /pr/tasks/{id}/` - Get task details
- `PUT /pr/tasks/{id}/` - Update task
- `DELETE /pr/tasks/{id}/` - Delete task

### Team Members
- `GET /pr/project-members/` - List project members
- `POST /pr/project-members/` - Add member to project

### Comments
- `GET /pr/comments/` - List comments
- `POST /pr/comments/` - Add comment to task

### Documentation
- `GET /swagger/` - Interactive Swagger UI
- `GET /redoc/` - ReDoc documentation

## Authentication

The API uses JWT (JSON Web Token) authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-access-token>
```

### Token Configuration
- **Access Token Lifetime**: 5 days
- **Refresh Token Lifetime**: 10 days
- **Token Rotation**: Enabled for security

## Models

### User
- Custom user model extending AbstractUser
- UUID primary key
- Email and username fields
- JWT token support

### Project
- Name and description
- Owner (Foreign Key to User)
- Timestamps (created_at, updated_at)

### Task
- Title and description
- Status: To Do, In Progress, Done
- Priority: Low, Medium, High
- Assigned user and project relationships
- Due date

### ProjectMember
- User and project relationship
- Role: Admin or Member

### Comment
- Content and timestamps
- User and task relationships


### Database Migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

## Configuration

### Environment Variables
- `SECRET_KEY`: Django secret key (defaults to development key)
- `DEBUG`: Set to False in production

### Database
Currently configured for SQLite. For production, update `DATABASES` setting in `settings.py`.

### CORS and Security
Update `ALLOWED_HOSTS` and add CORS configuration for production deployment.

## Troubleshooting

### Token Issues
- Tokens are valid for 5 days by default
- Check browser DevTools for Authorization headers
- Verify tokens are not being cleared on invalid requests
- Use the debug script to test authentication flow

### Common Issues
1. **401 Unauthorized**: Check if token is included in request headers
2. **400 Bad Request**: Validation errors in request data
3. **CORS Issues**: Add proper CORS configuration for frontend

## API Usage Examples

### Login
```bash
curl -X POST http://localhost:8000/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username": "your_username", "password": "your_password"}'
```

### Create Project
```bash
curl -X POST http://localhost:8000/pr/projects/ \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name": "My Project", "description": "Project description"}'
```

### List Tasks
```bash
curl -X GET http://localhost:8000/pr/tasks/ \
  -H "Authorization: Bearer <token>"
```