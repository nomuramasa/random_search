jQuery(function($){
    //ajax送信

  for (var i=0; i<localStorage.length; i++) { // ストレージの中身の数だけくり返す
  // for (var i=localStorage.length-1; i>=0; i--) { // 新しい順ならこっち？

  	// var forCount = i;
  	// (function(i){
	    var id = localStorage.key(i);
	    if ( id.match(/randomMemo/) ){ // ランダムメモに関係あるデータのみ

		    var getjson = localStorage.getItem(id); 
		    var obj = JSON.parse(getjson); // JSON → オブジェクト
		    // console.log(obj)


		    $.ajax({
		        url : "/move_data",
		        type : "GET",
		        dataType:"html",
		        async: false,
		        data : {name: obj.name, star: obj.star, visit: obj.visit},
		        error : function(XMLHttpRequest, textStatus, errorThrown) {
							console.log("ajax通信に失敗しました");
							// console.log("XMLHttpRequest : " + XMLHttpRequest.status);
							// console.log("textStatus     : " + textStatus);
							// console.log("errorThrown    : " + errorThrown.message);	        
						},
		        success : function(response) {
	            console.log("ajax通信に成功しました");
	            // console.log(response)
		        },
		        complete: function(){}
		    });

			  // localStorage.removeItem(id) // ローカルストレージの、そのデータは消しておく

			} //if 
		// })(forCount); //function(i)

  } //for 


});