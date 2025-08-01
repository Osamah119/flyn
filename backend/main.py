from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Optional
import uuid

app = FastAPI()

# --- Pydantic Models ---
class VirtualCard(BaseModel):
    id: str = str(uuid.uuid4())
    card_name: str
    spending_limit: float
    status: str = 'active'

# --- In-memory "Database" ---
mock_cards_db: List[VirtualCard] = [
    VirtualCard(id="1", card_name="Marketing Campaign", spending_limit=5000.00),
    VirtualCard(id="2", card_name="Office Supplies", spending_limit=1500.00, status="frozen"),
]

# --- API Endpoints ---

@app.get("/")
def read_root():
    return {"message": "Welcome to the FLYN API"}

@app.get("/cards", response_model=List[VirtualCard])
def get_virtual_cards():
    """
    Retrieve a list of all virtual cards.
    """
    return mock_cards_db

@app.post("/cards", response_model=VirtualCard, status_code=201)
def create_virtual_card(card: VirtualCard):
    """
    Create a new virtual card.
    """
    mock_cards_db.append(card)
    return card
