$(init);

function init() {
  $("nav li").on("click", menuClick)

  $(".emulator.host>canvas")
  .on("mousedown",swallowEvent)
  .on("keydown",swallowEvent)
  .on("mouseup",swallowEvent)
  .on("contextmenu",swallowEvent);
  
}

function swallowEvent(e) {
  e.preventDefault();
}
function menuClick(e) {
  let page=$(e.target).data("page");
  $(".page").addClass("hidden");
  $(".page."+page).removeClass("hidden");
}
