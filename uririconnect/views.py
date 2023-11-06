from django.urls import reverse_lazy
from django.views import View
from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from django.http import JsonResponse
from .forms import CustomPasswordResetForm, UserRegistrationForm
from .models import User
from django.contrib.auth.views import PasswordResetView
from django.http import HttpResponse  # Import HttpResponse for testing
from .forms import UserLoginForm  # Import your UserLoginForm

def index(request):
    return render(request, 'index.html')


def login_view(request):
    if request.method == 'POST':
        form = UserLoginForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            user = User.objects.filter(email_address=email, user_password=password).first()

            if user:
                # User is authenticated, set the user in the session and redirect
                request.session['user_id'] = user.user_id
                if user.role_id.role_name == 'teacher':
                    return redirect('teacher_dashboard')
                elif user.role_id.role_name == 'parent':
                    return redirect('parent_dashboard')
                elif user.role_id.role_name == 'student':
                    return redirect('student_dashboard')
                elif user.role_id.role_name == 'security_staff':
                    return redirect('security_staff_dashboard')
            else:
                # Authentication failed, show error message
                error_message = "Invalid email or password."
                return render(request, 'login.html', {'form': form, 'error_message': error_message})
    else:
        form = UserLoginForm()

    return render(request, 'login.html', {'form': form})


def register_view(request):
    if request.method == 'POST':
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            user.set_password(form.cleaned_data['user_password'])  # Set password using set_password method
            user.save()
            login(request, user)
            # Redirect to a success page or home page
            return redirect('registration_success')  # Assuming 'registration_success' is the success page URL name
    else:
        form = UserRegistrationForm()
    return render(request, 'register.html', {'form': form})


from django.shortcuts import render, redirect
from .forms import CustomPasswordResetForm  # Import your custom password reset form if needed
from django.contrib import messages
from django.core.mail import send_mail

def custom_password_reset_view(request):
    if request.method == 'POST':
        form = CustomPasswordResetForm(request.POST)
        if form.is_valid():
            # Get the email address from the form data
            email = form.cleaned_data.get('email')
            
            # Implement your custom logic here, e.g., sending a password reset email
            # Send an email with reset instructions (you can customize this part)
            # Example using Django's send_mail function (configure your email settings in settings.py):
            # send_mail(
            #     'Password Reset',
            #     'Reset your password by clicking on the following link: [Reset Link]',
            #     'from@example.com',  # Sender's email address
            #     [email],  # Recipient's email address (extracted from the form)
            #     fail_silently=False,
            # )
            
            # Optionally, you can redirect the user to a password reset confirmation page
            # Redirect to a success page or show a success message (customize as needed)
            messages.success(request, 'Password reset instructions have been sent to your email.')
            return redirect('custom_password_reset_done')  # Assuming 'custom_password_reset_done' is your URL name for the reset done page
    else:
        form = CustomPasswordResetForm()
    
    return render(request, 'password_reset_form.html', {'form': form})

def custom_password_reset_done_view(request):
    # Implement your custom password reset done logic here if needed
    # For example, you can display a success message or redirect the user to a specific page
    return render(request, 'password_reset_done.html')


class CheckEmailExistenceView(View):
    def post(self, request):
        email = request.POST.get('email')
        user_exists = User.objects.filter(email_address=email).exists()
        return JsonResponse({'exists': user_exists})

def teacher_dashboard(request):
    # Retrieve the logged-in teacher user (you need to implement the authentication logic)
    user = User.objects.get(pk=request.user.id)
    return render(request, 'teacher_dashboard.html', {'user': user})

def parent_dashboard(request):
    # Retrieve the logged-in parent user (you need to implement the authentication logic)
    user = User.objects.get(pk=request.user.id)
    return render(request, 'parent_dashboard.html', {'user': user})

def student_dashboard(request):
    # Retrieve the logged-in student user (you need to implement the authentication logic)
    user = User.objects.get(pk=request.user.id)
    return render(request, 'student_dashboard.html', {'user': user})

def security_staff_dashboard(request):
    # Retrieve the logged-in student user (you need to implement the authentication logic)
    user = User.objects.get(pk=request.user.id)
    return render(request, 'security_staff_dashboard.html', {'user': user})
