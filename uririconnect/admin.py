from django.contrib import admin
from .models import Role, User, Event, EventRegistration, Resource, Class, Message, SecurityIncident, Assignment, Grade

models_to_register = [Role, User, Event, EventRegistration, Resource, Class, Message, SecurityIncident, Assignment, Grade]

for model in models_to_register:
    admin.site.register(model)
