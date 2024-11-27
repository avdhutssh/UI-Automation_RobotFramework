import random
import string
import datetime
from urllib.parse import urlsplit

__version__ = '1.0.0'

class CustomLibrary:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        pass

    def get_current_date(self, date_format="%Y-%m-%d"):
        current_date = datetime.datetime.now().strftime(date_format)
        return current_date

    def generate_random_name(self, length=8):
        name = "".join(random.choice(string.ascii_letters) for _ in range(length))
        return name
