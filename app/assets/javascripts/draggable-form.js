$(function(){
  var list = document.querySelector('ul.schedule-list');

  list.addEventListener('slip:reorder', function(e){
    e.target.parentNode.insertBefore(e.target, e.detail.insertBefore);
    console.log('here');
  }, false);

  list.addEventListener('slip:beforewait', function(e){
    if (e.target.className.indexOf('instant') > -1) e.preventDefault();
  }, false);

    list.addEventListener('slip:afterswipe', function(e){
      $(e.target).remove();
      // Add data-possible-date-id to form
    }, false);
  new Slip(list);
});
