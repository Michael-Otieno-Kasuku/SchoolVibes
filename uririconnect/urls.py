from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('password_reset/', views.custom_password_reset_view, name='password_reset'),
    path('password_reset_done/', views.custom_password_reset_done_view, name='custom_password_reset_done'),
    path('check_email_existence/', views.CheckEmailExistenceView.as_view(), name='check_email_existence'),
    path('<str:role>/dashboard/', views.dashboard, name='dashboard'),
]
