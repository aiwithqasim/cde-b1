import csv
        
def read_csv(filename:str) -> tuple:
    with open(filename, 'r') as f:
        reader = csv.reader(f)
        next(reader)  # skip the header
        return [tuple(row) for row in reader]