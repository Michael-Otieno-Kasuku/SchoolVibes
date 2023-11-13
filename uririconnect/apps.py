from django.apps import AppConfig
from django.db.models import BigAutoField

class UririconnectConfig(AppConfig):
    default_auto_field = BigAutoField()
    name = 'uririconnect'
