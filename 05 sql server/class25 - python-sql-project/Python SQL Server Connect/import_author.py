from insert import insert_author
from utils import read_csv

def import_authors_from_csv(filename: str) -> None:
    authors = read_csv(filename)
    for author in authors:
        insert_author(*author)

# Call the function
if __name__ == "__main__":
    import_authors_from_csv("authors.csv")  # Replace with your actual CSV filename
