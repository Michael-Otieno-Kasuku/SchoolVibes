from django.contrib import admin
from django.urls import include, path

urlpatterns=[
    path("uririconnect/", include("uririconnect.urls")),
    path("admin/",admin.site.urls),
]