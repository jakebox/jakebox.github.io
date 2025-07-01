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
});
