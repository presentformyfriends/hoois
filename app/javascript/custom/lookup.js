window.onload = function () {

    window.setTimeout("document.getElementById('flash').style.display='none';", 1500);
  
    const speed = 1000;
  
    setTimeout(function () {
      const flashFadeOut = document.getElementById('flash');
      flashFadeOut.classList.toggle('fade');
    }, speed);
  
    // Toggle 'active' class for menu button (DRY!)
    const menuBtn = document.querySelector('.menu-btn');
    const navbar = document.querySelector('.navbar');
    const navbarList = document.querySelector('.navbar-list');
  
    const toggleClass = () => {
  
      menuBtn.classList.toggle('active');
      navbar.classList.toggle('overlay');
      navbarList.classList.toggle('overlay-content');
      navbarList.classList.toggle('hidden');
  
    }
  
    // Menu button event listener
    menuBtn.addEventListener('click', () => {
  
      toggleClass();
  
    })
  
    // Keep menu items hidden unless media query = "min-width: 800px"
    function myFunction(x) {
      if (x.matches) { // If media query matches
        navbarList.classList.remove('hidden');
      } else {
        navbarList.classList.add('hidden');
      }
    }
  
    var x = window.matchMedia("(min-width: 800px)")
    myFunction(x) // Call listener function at run time
    x.addEventListener('change', myFunction) // Attach listener function on state changes
  
  };