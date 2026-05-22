import { useEffect, useState } from 'react';

const API_URL = import.meta.env.VITE_API_URL || '/api';

export default function App() {
  const [greeting, setGreeting] = useState('Loading...');

  useEffect(() => {
    // Tenta di chiamare il backend; se non c'è, mostra un messaggio statico.
    fetch(`${API_URL}/hello`)
      .then((res) => (res.ok ? res.text() : Promise.reject(res.status)))
      .then((text) => setGreeting(text))
      .catch(() => setGreeting('Hello from myapp (backend non raggiungibile)'));
  }, []);

  return (
    <main style={{ fontFamily: 'system-ui, sans-serif', padding: '2rem', maxWidth: '40rem', margin: '0 auto' }}>
      <h1>myapp</h1>
      <p>{greeting}</p>
      <p style={{ color: '#666', fontSize: '0.85rem' }}>
        Modifica <code>src/App.jsx</code> per iniziare.
      </p>
    </main>
  );
}
