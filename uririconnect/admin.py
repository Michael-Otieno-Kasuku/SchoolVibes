from django.contrib import admin
from . models import Role
from . models import User
from . models import Event
from . models import EventRegistration
from . models import Resource
from . models import Classe
from . models import Message
from . models import SecurityIncident
from . models import Assignment
from . models import Grade

admin.site.register(Role)
admin.site.register(User)
admin.site.register(Event)
admin.site.register(EventRegistration)
admin.site.register(Resource)
admin.site.register(Classe)
admin.site.register(Message)
admin.site.register(SecurityIncident)
admin.site.register(Assignment)
admin.site.register(Grade)