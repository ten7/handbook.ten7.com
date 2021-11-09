document.addEventListener('DOMContentLoaded', () => {
  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(
      document.querySelectorAll('.navbar-burger'
      ), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {
    // Add a click event on each of them
    $navbarBurgers.forEach( (el) => {
      el.addEventListener('click', () => {
        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);
        // Toggle the "is-active" class on both
        // the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
      });
    });
  }

  // Add click functionality to dropdown menu
  const navbarItem = document.querySelectorAll('.navbar-item')[0];

  document.addEventListener('click', (event) => {
    const withinBoundries = event.composedPath().includes(navbarItem);

    if (withinBoundries) {
      // Toggle open menu
      navbarItem.classList.toggle('is-active');
    } else {
      // Click anywhere to close
      if (navbarItem.classList.contains('is-active')) {
        navbarItem.classList.toggle('is-active');
      }
    }
  });
});
