window.onload = function () {

    // Eyes follow mouse pointer
    document.querySelector("body").addEventListener("mousemove", function (evt) {
      const eye = document.querySelectorAll(".pupil");
      eye.forEach(function (eye) {
        let x = eye.getBoundingClientRect().left + eye.clientWidth / 2;
        let y = eye.getBoundingClientRect().top + eye.clientHeight / 2;
  
        let radian = Math.atan2(evt.pageX - x, evt.pageY - y);
        let rotate = radian * (180 / Math.PI) * -1 + 270;
        eye.style.transform = "rotate(" + rotate + "deg)";
      });
    });
  
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
  