# Generated by Django 4.2.7 on 2023-11-14 06:20

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Assignments',
            fields=[
                ('assignment_id', models.AutoField(primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=100)),
                ('assignment_description', models.TextField()),
                ('due_date', models.DateField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
        ),
        migrations.CreateModel(
            name='Roles',
            fields=[
                ('role_id', models.AutoField(primary_key=True, serialize=False)),
                ('role_name', models.CharField(max_length=50, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Users',
            fields=[
                ('user_id', models.AutoField(primary_key=True, serialize=False)),
                ('first_name', models.CharField(max_length=50)),
                ('last_name', models.CharField(max_length=50)),
                ('email_address', models.EmailField(max_length=254, unique=True)),
                ('user_password', models.CharField(max_length=255)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('role_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.roles')),
            ],
        ),
        migrations.CreateModel(
            name='User_Resources',
            fields=[
                ('resource_id', models.AutoField(primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=100)),
                ('resource_description', models.TextField()),
                ('file_path', models.CharField(max_length=255)),
                ('uploaded_at', models.DateTimeField(auto_now_add=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='User_Phone_Numbers',
            fields=[
                ('phone_number', models.CharField(max_length=20, primary_key=True, serialize=False, unique=True)),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='Security_Incidents',
            fields=[
                ('security_id', models.AutoField(primary_key=True, serialize=False)),
                ('incident_details', models.TextField()),
                ('time_reported', models.DateTimeField(auto_now_add=True)),
                ('report_status', models.CharField(choices=[('Reported', 'Reported'), ('Under Investigation', 'Under Investigation'), ('Resolved', 'Resolved')], max_length=20)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('reporter_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='Messages',
            fields=[
                ('message_id', models.AutoField(primary_key=True, serialize=False)),
                ('message_content', models.TextField()),
                ('sent_at', models.DateTimeField(auto_now_add=True)),
                ('is_read', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('receiver_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='receiver', to='uririconnect.users')),
                ('sender_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sender', to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='Grades',
            fields=[
                ('grade_id', models.AutoField(primary_key=True, serialize=False)),
                ('score', models.DecimalField(decimal_places=2, max_digits=5)),
                ('grading_date', models.DateField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('assignment_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.assignments')),
                ('student_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='Events',
            fields=[
                ('event_id', models.AutoField(primary_key=True, serialize=False)),
                ('title', models.CharField(max_length=100, unique=True)),
                ('event_description', models.TextField()),
                ('event_date', models.DateField()),
                ('event_location', models.CharField(max_length=100)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('organizer_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='Event_Registrations',
            fields=[
                ('event_reg_id', models.AutoField(primary_key=True, serialize=False)),
                ('registration_date', models.DateField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('event_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.events')),
                ('user_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.CreateModel(
            name='Classes',
            fields=[
                ('class_id', models.AutoField(primary_key=True, serialize=False)),
                ('class_name', models.CharField(max_length=50)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('teacher_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users')),
            ],
        ),
        migrations.AddField(
            model_name='assignments',
            name='class_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.classes'),
        ),
        migrations.AddField(
            model_name='assignments',
            name='teacher_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='uririconnect.users'),
        ),
    ]
