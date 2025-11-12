// ---------- Current year ----------
document.getElementById('year').textContent = new Date().getFullYear();

// ---------- Theme toggle: default = dark (no class), light = body.theme-light ----------
(() => {
  const btn = document.getElementById('themeToggle');
  const STORAGE_KEY = 'theme'; // 'dark' | 'light'

  // Apply saved theme (default stays dark)
  const saved = localStorage.getItem(STORAGE_KEY);
  if (saved === 'light') document.body.classList.add('theme-light');

  // Keep button label simple (no emoji)
  if (btn) btn.textContent = 'Theme';

  btn?.addEventListener('click', () => {
    const isLight = document.body.classList.toggle('theme-light');
    localStorage.setItem(STORAGE_KEY, isLight ? 'light' : 'dark');
  });
})();

// ---------- Visitor counter ----------
(async function () {
  const el = document.getElementById('visitCount');
  try {
    const res = await fetch("https://b8lru7wzkk.execute-api.eu-north-1.amazonaws.com/prod/count", {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    });
    if (!res.ok) throw new Error('Bad response');
    const data = await res.json();
    el.textContent = (data && (data.visits ?? data.count ?? data.total)) ?? '—';
  } catch {
    el.textContent = '—';
  }
})();
