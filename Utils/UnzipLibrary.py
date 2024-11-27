import zipfile
from robot.api.deco import keyword

class UnzipLibrary:
    @keyword("Extract Zip File")
    def extract_zip_file(self, zip_file_path, extract_to):
        with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
            zip_ref.extractall(extract_to)
