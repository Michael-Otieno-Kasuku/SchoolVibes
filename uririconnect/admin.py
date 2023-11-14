from django.contrib import admin
from .models import Roles, Users, User_Phone_Numbers, Events, Event_Registrations, User_Resources, Classes, Messages, Security_Incidents, Assignments, Grades

models_to_register = [Roles, Users, User_Phone_Numbers, Events, Event_Registrations, User_Resources, Classes, Messages, Security_Incidents, Assignments, Grades]

for model in models_to_register:
    admin.site.register(model)
