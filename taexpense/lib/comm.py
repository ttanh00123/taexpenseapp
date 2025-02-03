from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pyodbc

app = FastAPI()

# Database connection
server = 'tcp:taexpense.database.windows.net'
database = 'TAExpense'
username = 'ttanh'
password = 'Bitbo123@'
driver = '{ODBC Driver 17 for SQL Server}'

conn = pyodbc.connect(
    f'DRIVER={driver};SERVER={server};PORT=1433;DATABASE={database};UID={username};PWD={password}'
)

class Transaction(BaseModel):
    content: str
    currency: str
    amount: float
    type: str
    date: str
    category: str
    tags: str
    notes: str

@app.post("/addTransaction")
async def add_transaction(transaction: Transaction):
    try:
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO transactions (content, currency, amount, type, date, category, tags, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', transaction.content, transaction.currency, transaction.amount, transaction.type, transaction.date, transaction.category, transaction.tags, transaction.notes)
        conn.commit()
        return {"message": "Transaction added successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/")
async def read_root():
    return {"message": "Welcome to the TA Expense API"}

