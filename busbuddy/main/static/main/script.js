document.addEventListener("DOMContentLoaded", function () {
  const mobileToggle = document.getElementById("mobile-toggle");
  const mobileMenu = document.getElementById("mobile-menu");

  if (mobileToggle && mobileMenu) {
    mobileToggle.addEventListener("click", function () {
      const isOpen = mobileMenu.classList.toggle("open");
      mobileToggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
    });
  }

  const stopsContainer = document.getElementById("stops-container");
  const addStopButton = document.getElementById("add-stop");

  if (stopsContainer && addStopButton) {
    addStopButton.addEventListener("click", function () {
      const row = document.createElement("div");
      row.className = "form-grid stop-field";
      row.innerHTML = `
        <div class="form-group">
          <label>Stop name</label>
          <input type="text" name="stops[]" placeholder="Intermediate stop">
        </div>
        <div class="form-group">
          <label>Stop time</label>
          <input type="time" name="stop_times[]">
        </div>
      `;
      stopsContainer.appendChild(row);
    });
  }

  document.querySelectorAll("[data-seat-input]").forEach(function (input) {
    input.addEventListener("input", function () {
      const target = document.getElementById(input.dataset.totalTarget);
      const price = Number(input.dataset.price || 0);
      const seats = Number(input.value || 1);
      if (target) {
        target.textContent = String(price * seats);
      }
    });
  });
});
