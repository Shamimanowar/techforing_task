from django.db import models
from django.contrib.auth.models import AbstractUser
from uuid import uuid4
from external.abastacts import BaseModel
from django.utils.translation import gettext_lazy as _


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid4, editable=False)
    email = models.EmailField(unique=True)
    date_joined = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = _('user')
        
        def __str__(self):
            return self.username or str(self.id)[:8]

class Project(BaseModel):
    name = models.CharField(max_length=255, help_text=_("What is the name of the project?"))
    description = models.TextField(help_text=_("What is the project about?"))
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='projects', help_text=_("Who is the owner of the project?"))

    class Meta:
        def __str__(self):
            return self.name
