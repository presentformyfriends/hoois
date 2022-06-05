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

};