from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name="index"),
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('password_reset/', views.custom_password_reset_view, name='password_reset'),
    path('password_reset_done/', views.custom_password_reset_done_view, name='custom_password_reset_done'),
    path('check_email_existence/', views.CheckEmailExistenceView.as_view(), name='check_email_existence'),
    path('teacher/dashboard/', views.teacher_dashboard, name='teacher_dashboard'),
    path('parent/dashboard/', views.parent_dashboard, name='parent_dashboard'),
    path('student/dashboard/', views.student_dashboard, name='student_dashboard'),
    path('security_staff/dashboard/', views.security_staff_dashboard, name='security_staff_dashboard'),
]
