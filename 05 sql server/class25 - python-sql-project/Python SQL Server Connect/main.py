import logging, sys
from connect import create_connection

# config logging to console
logger = logging.getLogger(__name__)
logging.basicConfig(
    stream=sys.stdout, 
    encoding='utf-8', 
    format='%(levelname)s:%(message)s',
    level=logging.DEBUG
)

# create a database connection
conn = create_connection()
if conn:
    logging.info('Connected to the SQL Server database successfully.')
    conn.close()

