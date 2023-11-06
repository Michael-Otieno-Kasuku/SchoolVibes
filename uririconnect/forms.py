from django import forms
from .models import User, Role

class UserRegistrationForm(forms.ModelForm):
    role_id = forms.ModelChoiceField(
        queryset=Role.objects.all(),
        to_field_name='role_id',
        empty_label=None,
        widget=forms.Select(attrs={'class': 'form-control select2-container'})
    )
    user_password = forms.CharField(
        widget=forms.PasswordInput(attrs={'class': 'form-control'}),
        min_length=8
    )
    confirm_password = forms.CharField(
        widget=forms.PasswordInput(attrs={'class': 'form-control'}),
        min_length=8
    )

    class Meta:
        model = User
        fields = ['role_id', 'first_name', 'last_name', 'email_address', 'user_password', 'confirm_password', 'phone_number']

    def clean_email_address(self):
        email = self.cleaned_data['email_address']
        if User.objects.filter(email_address=email).exists():
            raise forms.ValidationError("Email already exists. Please use a different email address.")
        return email

    def clean_phone_number(self):
        phone_number = self.cleaned_data['phone_number']
        # Validate phone number format here (regex or other validation logic)
        return phone_number

    def clean(self):
        cleaned_data = super().clean()
        password = cleaned_data.get("user_password")
        confirm_password = cleaned_data.get("confirm_password")

        if password != confirm_password:
            raise forms.ValidationError("Passwords do not match.")

        # Password validation: Check if it meets the criteria (alphanumeric, minimum length 8)
        if not re.match(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$', password):
            raise forms.ValidationError("Password must be at least 8 characters long and contain both letters and numbers.")

        return cleaned_data
