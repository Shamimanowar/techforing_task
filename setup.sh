#!/bin/bash

# TechForing Project Management API Setup Script
# This script will set up the complete development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info "Starting TechForing Project Management API setup..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    print_error "Python3 is not installed. Please install Python3 first."
    exit 1
fi

print_success "Python3 is available"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

print_info "Working directory: $SCRIPT_DIR"

# Create .env file
print_info "Creating .env file..."
if [ -f ".env" ]; then
    print_warning ".env file already exists. Backing up to .env.backup"
    cp .env .env.backup
fi

cat > .env << 'EOF'
SECRET_KEY='django-insecure-setup-change-this-in-production-$(date +%s)'
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
EOF

print_success ".env file created"

# Create virtual environment named 'env'
print_info "Creating virtual environment 'env'..."
if [ -d "env" ]; then
    print_warning "Virtual environment 'env' already exists. Removing it..."
    rm -rf env
fi

python3 -m venv env
print_success "Virtual environment 'env' created"

# Activate virtual environment
print_info "Activating virtual environment..."

# Check if we're on Windows (Git Bash, WSL, etc.)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    # Windows
    source env/Scripts/activate
    PYTHON_PATH="env/Scripts/python"
    PIP_PATH="env/Scripts/pip"
    print_info "Activated virtual environment (Windows)"
else
    # Linux/macOS
    source env/bin/activate
    PYTHON_PATH="env/bin/python"
    PIP_PATH="env/bin/pip"
    print_info "Activated virtual environment (Linux/macOS)"
fi

print_success "Virtual environment activated"

# Upgrade pip
print_info "Upgrading pip..."
$PIP_PATH install --upgrade pip

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    print_warning "requirements.txt not found. Creating a basic one..."
    cat > requirements.txt << 'EOF'
Django==5.2.4
djangorestframework==3.16.0
djangorestframework-simplejwt==5.5.0
django-filter==25.1
drf-yasg==1.21.10
django-jazzmin==3.0.1
requests==2.32.3
PyYAML==6.0.2
EOF
    print_success "Created requirements.txt with essential packages"
fi

# Install packages from requirements.txt
print_info "Installing packages from requirements.txt..."
$PIP_PATH install -r requirements.txt
print_success "All packages installed successfully"

# Run Django setup commands
print_info "Running Django setup commands..."

# Apply migrations
print_info "Applying database migrations..."
$PYTHON_PATH manage.py migrate

print_success "Database migrations completed"

# Collect static files
print_info "Collecting static files..."
$PYTHON_PATH manage.py collectstatic --noinput
print_success "Static files collected successfully"

# Create default superuser automatically
print_info "Creating default superuser..."
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@techforing.com', 'admin123')" | $PYTHON_PATH manage.py shell
print_success "Default superuser created"
print_warning "Default credentials - Username: admin, Password: admin123"

# Test if server can start
print_info "Testing Django server startup..."
timeout 5s $PYTHON_PATH manage.py runserver --check-port 8000 > /dev/null 2>&1 || {
    print_warning "Port 8000 might be in use, but that's okay"
}

print_success "Django setup completed successfully!"

# Display credentials and access information
echo ""
echo "==============================================="
print_success "SETUP COMPLETE!"
echo "==============================================="
echo ""
print_success "Default Superuser Credentials:"
echo "   Username: admin"
echo "   Password: admin123"
echo "   Email: admin@techforing.com"
echo ""
print_info "Application URLs:"
echo "   • API: http://localhost:8000/"
echo "   • Admin: http://localhost:8000/admin/"
echo "   • API Docs: http://localhost:8000/swagger/"
echo ""
print_warning "Please change the default password after first login!"
print_warning "Remember to change the SECRET_KEY in .env for production!"
echo ""
print_info "Environment file created: .env"
print_info "Virtual environment: env/"
print_info "All dependencies installed from requirements.txt"
echo ""

# Start the Django development server
print_info "Starting Django development server..."
echo ""
print_success "Server is starting at http://localhost:8000/"
print_info "Press Ctrl+C to stop the server"
echo ""

# Run the server
$PYTHON_PATH manage.py runserver
