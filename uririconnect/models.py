from django.db import models

class Roles(models.Model):
    role_id = models.AutoField(primary_key=True)
    role_name = models.CharField(max_length=50, unique=True)

class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    role_id = models.ForeignKey(Roles, on_delete=models.CASCADE)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email_address = models.EmailField(unique=True)
    user_password = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class User_Phone_Numbers(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    phone_number = models.CharField(max_length=20, unique=True, primary_key=True)

class Events(models.Model):
    event_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100, unique=True)
    event_description = models.TextField()
    event_date = models.DateField()
    event_location = models.CharField(max_length=100)
    organizer_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Event_Registrations(models.Model):
    event_reg_id = models.AutoField(primary_key=True)
    event_id = models.ForeignKey(Events, on_delete=models.CASCADE)
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    registration_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class User_Resources(models.Model):
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    resource_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100)
    resource_description = models.TextField()
    file_path = models.CharField(max_length=255)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Classes(models.Model):
    class_id = models.AutoField(primary_key=True)
    class_name = models.CharField(max_length=50)
    teacher_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Messages(models.Model):
    message_id = models.AutoField(primary_key=True)
    sender_id = models.ForeignKey(Users, on_delete=models.CASCADE, related_name='sender')
    receiver_id = models.ForeignKey(Users, on_delete=models.CASCADE, related_name='receiver')
    message_content = models.TextField()
    sent_at = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Security_Incidents(models.Model):
    security_id = models.AutoField(primary_key=True)
    reporter_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    incident_details = models.TextField()
    time_reported = models.DateTimeField(auto_now_add=True)
    report_status_choices = [('Reported', 'Reported'), ('Under Investigation', 'Under Investigation'), ('Resolved', 'Resolved')]
    report_status = models.CharField(max_length=20, choices=report_status_choices)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Assignments(models.Model):
    assignment_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100)
    assignment_description = models.TextField()
    due_date = models.DateField()
    teacher_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    class_id = models.ForeignKey(Classes, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Grades(models.Model):
    grade_id = models.AutoField(primary_key=True)
    assignment_id = models.ForeignKey(Assignments, on_delete=models.CASCADE)
    student_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    score = models.DecimalField(max_digits=5, decimal_places=2)
    grading_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
