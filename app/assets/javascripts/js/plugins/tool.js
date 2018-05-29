function load_pic(){
  $.blockUI({ css: { 
            border: 'none', 
            padding: '15px', 
            backgroundColor: '#000', 
            '-webkit-border-radius': '10px', 
            '-moz-border-radius': '10px', 
            opacity: .5, 
            color: '#fff' 
        } }); 
  return true;
}

 // Convert dataURL to Blob object
  function dataURLtoBlob(dataURL) {
    // Decode the dataURL    
    var binary = atob(dataURL.split(',')[1]);
    // Create 8-bit unsigned array
    var array = [];
    for(var i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
    }
    // Return our Blob object
    return new Blob([new Uint8Array(array)], {type: 'image/png'});
  }

function save_image(id,report_type){
    // Create new form data
    var fd = new FormData();
    var count = $(".charts-holder").size();
    fd.append("type",report_type);
    fd.append("id",id);
    fd.append("count",count);
    for (var i=0;i<count;i++){
        chart = $(".charts-holder")[i];
        chart_object = $(chart).highcharts(); //get highcharts object
        svg = chart_object.getSVG();  //get svg string

        canvas = document.createElement('canvas'); //create a empty canvas

        window.canvg(canvas, svg); //render the svg on the canvas
  
        dataURL = canvas.toDataURL('image/jpg'); //convert canvas  to  base64 data

        //dataURLtoBlob is for Convert dataURL to Blob object
        image_blob = dataURLtoBlob(dataURL);
        // var chart_id = 'testreports_' + id + '_' + count;
        // Append our Canvas image file to the form data
        fd.append('image_'+i, image_blob);
    }
    $.ajax({
        url: "/save_image",
        type: "POST",
        data: fd,
        processData: false,
        contentType: false,
    });
    return count;
}

function operation_sucess(data){
    swal({
            title:"操作成功!", 
            text:data, 
            type:"success",
            confirmButtonText: '刷新页面',
            showCancelButton: true
        },
        function(isConfirm){
            if(isConfirm){
                window.location.href = window.location.href;
            }    
        }); 
}