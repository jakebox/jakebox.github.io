document.addEventListener("DOMContentLoaded", function () {
  function updateEmacsUptime() {
    const startTime = new Date("2020-08-15T00:00:00");
    const now = new Date();
    const diff = now - startTime;

    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
    const minutes = Math.floor((diff / (1000 * 60)) % 60);
    const seconds = Math.floor((diff / 1000) % 60);

    const uptimeElement = document.getElementById("emacs-uptime");
    if (uptimeElement) {
      uptimeElement.textContent = `Uptime: ${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds`;
    }
  }

  // Update every minute
  setInterval(updateEmacsUptime, 1000);
  updateEmacsUptime(); // Initial call
  
  // Initialize theme on page load
  initializeTheme();
});

function getSystemTheme() {
  return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

function getStoredTheme() {
  return localStorage.getItem('theme');
}

function setTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  localStorage.setItem('theme', theme);
}

function initializeTheme() {
  const storedTheme = getStoredTheme();
  const systemTheme = getSystemTheme();
  const theme = storedTheme || systemTheme;
  setTheme(theme);
}

function toggleTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme');
  const newTheme = currentTheme === "dark" ? "light" : "dark";
  setTheme(newTheme);
}
