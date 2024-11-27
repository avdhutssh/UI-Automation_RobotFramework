import RPi.GPIO as GPIO
import sys

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(21, GPIO.OUT)

if len(sys.argv) != 2:
    print("Usage: python Device_OFF_ON.py [ON|OFF]")
    sys.exit(1)

command = sys.argv[1].upper()

try:
    if command == "ON":
        GPIO.output(21, True)
        print("Device turned ON")
    elif command == "OFF":
        GPIO.output(21, False)
        print("Device turned OFF")
    else:
        print("Invalid command. Use ON or OFF.")
        sys.exit(1)
finally:
    pass  # Do not clean up the GPIO to keep the state