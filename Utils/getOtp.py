import pyotp

def get_otp():
    secret_key = ''
    totp = pyotp.TOTP(secret_key)
    otp = totp.now()
    print(f"Your OTP is: {otp}")
    return otp

otp = get_otp()
print(f"Your OTP is: {otp}")
