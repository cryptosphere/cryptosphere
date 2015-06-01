"use strict";

function openSesame() {
  $("#door-l").css("transform", "translateX(-150%)");
  $("#door-r").css("transform", "translateX(150%)");
}

$("#passbutton").click(openSesame);

$('#passfield').on('keydown', function(e) {
  if (e.which == 13) {
    openSesame();
  }
});
