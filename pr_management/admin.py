from django.contrib import admin
from .models import Project, User


# Define the inlines
class ProjectInline(admin.TabularInline):
    model = Project
    extra = 0
    can_delete = False
    
    def has_change_permission(self, request, obj = None):
        return super().has_change_permission(request, obj)
    
    
# Register the models with the admin site
@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'date_joined', 'last_login')
    search_fields = ('username', 'email')
    ordering = ['-date_joined', ]

    inlines = [
        ProjectInline,
        ]