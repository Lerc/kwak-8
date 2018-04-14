$(init);

function init() {
  $("nav li").on("click", menuClick)

  $(".emulator.host>canvas")
  .on("mousedown",swallowEvent)
  .on("keydown",swallowEvent)
  .on("mouseup",swallowEvent)
  .on("contextmenu",swallowEvent);
  
  let tabs = $.map($(".menu li"),a=>$(a).data("page"));
  let hash = location.hash.slice(1);
  if (tabs.includes(hash)) {
    showPage(hash);
  }
}

function swallowEvent(e) {
  e.preventDefault();
}

function showPage(page) {
  $(".page").addClass("hidden");
  $(".page."+page).removeClass("hidden");
  location.hash="#"+page;
}
function menuClick(e) {
  showPage($(e.target).data("page"));
}
