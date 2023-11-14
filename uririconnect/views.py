from django.urls import reverse_lazy
from django.views import View
from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from django.contrib import messages
from django.http import JsonResponse
from django.core.mail import send_mail
from django.contrib.auth.views import PasswordResetView
from .forms import CustomPasswordResetForm, UserRegistrationForm, UserLoginForm
from .models import Users  # Update the import statement to match your model name

def index(request):
    return render(request, 'index.html')

def login_view(request):
    if request.method == 'POST':
        form = UserLoginForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            user = authenticate(request, email_address=email, user_password=password)

            if user:
                login(request, user)
                role_name = user.role_id.role_name.lower()
                return redirect(f'{role_name}_dashboard')
            else:
                messages.error(request, "Invalid email or password.")
    else:
        form = UserLoginForm()

    return render(request, 'login.html', {'form': form})

def register_view(request):
    if request.method == 'POST':
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            user.set_password(form.cleaned_data['user_password'])
            user.save()
            login(request, user)
            messages.success(request, 'Registration successful.')
            return redirect('registration_success')
    else:
        form = UserRegistrationForm()

    return render(request, 'register.html', {'form': form})

def custom_password_reset_view(request):
    if request.method == 'POST':
        form = CustomPasswordResetForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data.get('email')
            send_mail('Password Reset', 'Reset your password by clicking on the following link: [Reset Link]', 'from@example.com', [email], fail_silently=False)
            messages.success(request, 'Password reset instructions have been sent to your email.')
            return redirect('custom_password_reset_done')
    else:
        form = CustomPasswordResetForm()

    return render(request, 'password_reset_form.html', {'form': form})

def custom_password_reset_done_view(request):
    return render(request, 'password_reset_done.html')

class CheckEmailExistenceView(View):
    def post(self, request):
        email = request.POST.get('email')
        user_exists = Users.objects.filter(email_address=email).exists()  # Update the model reference
        return JsonResponse({'exists': user_exists})

def dashboard(request, role):
    user = Users.objects.get(pk=request.user.id)  # Update the model reference
    return render(request, f'{role}_dashboard.html', {'user': user})
