import React, { useState, useEffect } from 'react';
import './App.css';

const API_URL = 'http://localhost:8000'; // Backend API URL

function App() {
  const [cards, setCards] = useState([]);
  const [cardName, setCardName] = useState('');
  const [spendingLimit, setSpendingLimit] = useState('');

  // Fetch cards from the backend when the component mounts
  useEffect(() => {
    fetch(`${API_URL}/cards`)
      .then(response => response.json())
      .then(data => setCards(data))
      .catch(error => console.error('Error fetching cards:', error));
  }, []);

  const handleCreateCard = (e) => {
    e.preventDefault();
    const newCard = {
      card_name: cardName,
      spending_limit: parseFloat(spendingLimit),
    };

    fetch(`${API_URL}/cards`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newCard),
    })
      .then(response => response.json())
      .then(createdCard => {
        setCards([...cards, createdCard]);
        // Clear form
        setCardName('');
        setSpendingLimit('');
      })
      .catch(error => console.error('Error creating card:', error));
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>FLYN - Virtual Cards Management</h1>
      </header>
      <main>
        <div className="card-form">
          <h2>Create New Virtual Card</h2>
          <form onSubmit={handleCreateCard}>
            <input
              type="text"
              placeholder="Card Name (e.g., Marketing)"
              value={cardName}
              onChange={(e) => setCardName(e.target.value)}
              required
            />
            <input
              type="number"
              placeholder="Spending Limit"
              value={spendingLimit}
              onChange={(e) => setSpendingLimit(e.target.value)}
              required
            />
            <button type="submit">Create Card</button>
          </form>
        </div>

        <div className="card-list">
          <h2>Existing Cards</h2>
          {cards.length > 0 ? (
            <ul>
              {cards.map(card => (
                <li key={card.id}>
                  <strong>{card.card_name}</strong> - Limit: {card.spending_limit.toFixed(2)} SAR - Status: {card.status}
                </li>
              ))}
            </ul>
          ) : (
            <p>No virtual cards found. Create one above.</p>
          )}
        </div>
      </main>
    </div>
  );
}

export default App;
