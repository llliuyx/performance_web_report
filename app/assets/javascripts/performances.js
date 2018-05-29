//= require js/plugins/jquery.dataTables.js
//= require js/plugins/dataTables.bootstrap.js
//= require js/plugins/dataTables.responsive.js
//= require js/plugins/dataTables.tableTools.min.js


$(document).ready(function () {
  $('.dataTables-example').dataTable({
    responsive: true,
    "dom": 'T<"clear">lfrtip',
    "tableTools": {
      "sSwfPath": "/assets/js/plugins/swf/copy_csv_xls_pdf.swf"
    },
    "aLengthMenu": [25, 50, 100]
  });
});