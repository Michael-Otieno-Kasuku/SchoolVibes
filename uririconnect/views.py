from django.shortcuts import render

def index(request):
    return render(request, 'index.html')

from django.contrib.auth import authenticate, login

def login_view(request):
    if request.method == 'POST':
        email = request.POST['email']
        password = request.POST['password']
        user = authenticate(request, email=email, password=password)
        if user is not None:
            login(request, user)
            # Redirect to a success page
        else:
            # Return an error message to the template
            error_message = "Invalid email or password."
            return render(request, 'login.html', {'error_message': error_message})
    return render(request, 'login.html')
