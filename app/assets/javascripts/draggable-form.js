function rerank(){
  var date1 = $('#date1'),
      date2 = $('#date2'),
      date3 = $('#date3'),
      recs  = $('.schedule-list-item'),
      possibleDateIds = $.map(recs, function(rec, i){
        return $(rec).data('possible-date-id');
      });

  $(date1).attr('value', possibleDateIds[0]);
  $(date2).attr('value', possibleDateIds[1]);
  $(date3).attr('value', possibleDateIds[2]);
}

$(function(){
  var list = document.querySelector('ul.schedule-list');

  list.addEventListener('slip:reorder', function(e){
    e.target.parentNode.insertBefore(e.target, e.detail.insertBefore);
    rerank();
  }, false);

  list.addEventListener('slip:beforewait', function(e){
    if (e.target.className.indexOf('instant') > -1) e.preventDefault();
  }, false);

  list.addEventListener('slip:afterswipe', function(e){
    var dateId = $(e.target).data('possible-date-id');
    $(e.target).remove();

    $.ajax({
      url: '/possible_interview_blocks/' + dateId,
      type: 'DELETE',
      success: function(result){
        // response in views/shared/destroy.js.erb
      }
    });

  }, false);
  new Slip(list);
});
