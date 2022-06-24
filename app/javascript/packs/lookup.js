window.onload = function() {

  window.setTimeout("document.getElementById('flash').style.display='none';", 5000);
  
  const speed = 2000;
  
  setTimeout(function() {
    const flashFadeOut = document.getElementById('flash');
    flashFadeOut.classList.toggle('fade');
  }, speed);

};