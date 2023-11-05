"""
Module containing Django models for the database schema.

This module defines the following models:
- Roles: Represents different roles in the system.
- Users: Represents user information, including authentication details.
- Events: Represents events with associated details and organizers.
- EventRegistrations: Represents user registrations for events.
- Resources: Represents resources with titles, descriptions, and file paths.
- Classes: Represents different classes with associated teachers.
- Messages: Represents messages sent between users.
- SecurityIncidents: Represents security incidents reported by users.
- Assignments: Represents assignments with titles, descriptions, due dates, and associated teachers and classes.
- Grades: Represents student grades for assignments.

Each model corresponds to a table in the database schema and includes appropriate fields and relationships.

Note: Some fields, such as user_password, are intended to store hashed passwords and should be handled securely in the application.
"""

from django.db import models

class Roles(models.Model):
    role_id = models.AutoField(primary_key=True)
    role_name = models.CharField(max_length=50, null=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.role_id, self.role_name, self.created_at, self.updated_at

class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    role_id = models.ForeignKey(Roles, on_delete=models.CASCADE)
    first_name = models.CharField(max_length=50, null=False)
    last_name = models.CharField(max_length=50, null=False)
    email_address = models.EmailField(unique=True, null=False)
    user_password = models.CharField(max_length=255)  # Hashed password handled in the application
    phone_number = models.CharField(max_length=20, unique=True, null=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.user_id, self.role_id, self.first_name, self.last_name, self.email_address, self.user_password, self.phone_number, self.created_at, self.updated_at

class Events(models.Model):
    event_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100, null=False)
    event_description = models.TextField(null=True)
    event_date = models.DateField(null=True)
    event_location = models.CharField(max_length=100, null=True)
    organizer_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.event_id, self.title, self.event_description, self.event_date, self.event_location, self.organizer_id, self.created_at, self.updated_at

class EventRegistrations(models.Model):
    event_reg_id = models.AutoField(primary_key=True)
    event_id = models.ForeignKey(Events, on_delete=models.CASCADE)
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    registration_date = models.DateField(null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.event_reg_id, self.event_id, self.user_id, self.registration_date, self.created_at, self.updated_at

class Resources(models.Model):
    resource_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100, null=False)
    resource_description = models.TextField(null=True)
    file_path = models.CharField(max_length=255, null=True)
    uploaded_by = models.ForeignKey(Users, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.resource_id, self.title, self.resource_description, self.file_path, self.uploaded_by, self.created_at, self.updated_at

class Classes(models.Model):
    class_id = models.AutoField(primary_key=True)
    class_name = models.CharField(max_length=50, null=False)
    teacher_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.class_id, self.class_name, self.teacher_id, self.created_at, self.updated_at

class Messages(models.Model):
    message_id = models.AutoField(primary_key=True)
    sender_id = models.ForeignKey(Users, related_name='sender_messages', on_delete=models.CASCADE)
    receiver_id = models.ForeignKey(Users, related_name='receiver_messages', on_delete=models.CASCADE)
    message_content = models.TextField(null=True)
    sent_at = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.message_id, self.sender_id, self.receiver_id, self.message_content, self.sent_at, self.is_read, self.created_at, self.updated_at

class SecurityIncidents(models.Model):
    security_id = models.AutoField(primary_key=True)
    reporter_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    incident_details = models.TextField(null=True)
    time_reported = models.DateTimeField(auto_now_add=True)
    report_status = models.CharField(max_length=20, choices=[('Reported', 'Reported'), ('Under Investigation', 'Under Investigation'), ('Resolved', 'Resolved')])
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.security_id, self.reporter_id, self.incident_details, self.time_reported, self.report_status, self.created_at, self.updated_at

class Assignments(models.Model):
    assignment_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100, null=False)
    assignment_description = models.TextField(null=True)
    due_date = models.DateField(null=True)
    teacher_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    class_id = models.ForeignKey(Classes, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.assignment_id, self.title, self.assignment_description, self.due_date, self.teacher_id, self.class_id, self.created_at, self.updated_at

class Grades(models.Model):
    grade_id = models.AutoField(primary_key=True)
    assignment_id = models.ForeignKey(Assignments, on_delete=models.CASCADE)
    student_id = models.ForeignKey(Users, on_delete=models.CASCADE)
    score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    grading_date = models.DateField(null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.grade_id, self.assignment_id, self.student_id, self.score, self.grading_date,self.created_at, self.updated_at
