// Current year
document.getElementById('year').textContent = new Date().getFullYear();

// Theme toggle (prefers-color-scheme aware)
const root = document.documentElement;
const toggle = document.getElementById('themeToggle');
let dark = true;
toggle.addEventListener('click', () => {
  dark = !dark;
  // Simple theme switch: invert core vars for a light mode
  if (!dark) {
    root.style.setProperty('--bg', '#f6f8fc');
    root.style.setProperty('--card', '#ffffff');
    root.style.setProperty('--text', '#0b1220');
    root.style.setProperty('--muted', '#4a576d');
    root.style.setProperty('--shadow', '0 8px 24px rgba(0,0,0,0.08)');
    document.body.style.background = 'var(--bg)';
  } else {
    root.style.setProperty('--bg', '#0b1220');
    root.style.setProperty('--card', '#121a2b');
    root.style.setProperty('--text', '#e7eefc');
    root.style.setProperty('--muted', '#8ea0c0');
    root.style.setProperty('--shadow', '0 8px 24px rgba(4,10,24,0.45)');
    document.body.style.background = 'radial-gradient(1200px 800px at 80% -10%, #1b2540, transparent 60%), var(--bg)';
  }
});

// Visitor counter (wire this to your API Gateway endpoint)
(async function () {
  const el = document.getElementById('visitCount');
  try {
    // Replace with your deployed API endpoint:
    const res = await fetch("https://b8lru7wzkk.execute-api.eu-north-1.amazonaws.com/prod/count", {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    });
    if (!res.ok) throw new Error('Bad response');
    const data = await res.json();
    el.textContent = data.visits ?? '—';
  } catch (e) {
    el.textContent = '—';
  }
})();
