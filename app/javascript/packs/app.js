window.onload = function() {

  // Eyes follow mouse pointer
  document.querySelector("body").addEventListener("mousemove", function(evt) {

    const eye = document.querySelectorAll(".eyes");
    eye.forEach(function (eye) {    
      let x = eye.getBoundingClientRect().left + eye.clientWidth / 2;
      let y = eye.getBoundingClientRect().top + eye.clientHeight / 2;

      let radian = Math.atan2(evt.pageX - x, evt.pageY - y);
      let rotate = radian * (180 / Math.PI) * -1 + 270;
      eye.style.transform = "rotate(" + rotate + "deg)";
    });

  });

  // Eyes follow caret in input field when user types

  const getCaretCoordinates = require("textarea_caret");

  document.querySelector("text").addEventListener("input", function () {
    const caret = getCaretCoordinates(this, this.selectionEnd);
    console.log("(top, left, height) = (%s, %s, %s)", caret.top, caret.left, caret.height);
  })

};



// const eye1 = document.querySelector('.eye-left');
// const eye2 = document.querySelector('.eye-right');
// const eyes = document.querySelectorAll('.eyes');

// window.addEventListener('mousemove', (evt) => {
//   const x = (window.innerWidth / 2 - evt.pageX) / 160;
//   const y = (windows.innerHeight / 2 - evt.pageY) / 160;
//   eyes.style.transform = `translateY(${y}px) translateY(${x}px)`;
// } )