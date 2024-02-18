import csv

def read_csv_file(filename):
    data=[]
    with open(filename) as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            data.append(row)
    return data