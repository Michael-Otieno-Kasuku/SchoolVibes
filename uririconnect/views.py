from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login, authenticate
from .models import User
from django.contrib.auth.views import PasswordResetView

def index(request):
    return render(request, 'index.html')


def login_view(request):
    if request.method == 'POST':
        email = request.POST['email']
        password = request.POST['password']
        user = authenticate(request, email=email, password=password)
        if user is not None:
            login(request, user)
            # Redirect to a success page
            return redirect('success_page')  # Replace 'success_page' with the actual URL name
        else:
            # Return an error message to the template
            error_message = "Invalid email or password."
            return render(request, 'login.html', {'error_message': error_message})
    return render(request, 'login.html')


def register_view(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            # You can set additional fields from your User model here if needed
            user.save()
            # Log the user in
            login(request, user)
            # Redirect to a success page or home page
            return redirect('registration_success')  # Assuming 'registration_success' is the success page URL name
    else:
        form = UserCreationForm()
    return render(request, 'register.html', {'form': form})


class CustomPasswordResetView(PasswordResetView):
    form_class = PasswordResetForm  # Assuming you have a custom PasswordResetForm defined
    email_template_name = 'password_reset_email.html'
    subject_template_name = 'password_reset_subject.txt'
    success_url = reverse_lazy('password_reset_done')

