import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import App from './App.jsx';

describe('App', () => {
  beforeEach(() => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      text: () => Promise.resolve('Hello from myapp'),
    });
  });

  it('renders the project title', () => {
    render(<App />);
    expect(screen.getByText('myapp')).toBeInTheDocument();
  });

  it('shows greeting from API', async () => {
    render(<App />);
    await waitFor(() => {
      expect(screen.getByText('Hello from myapp')).toBeInTheDocument();
    });
  });
});
