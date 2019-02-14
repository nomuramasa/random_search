//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .


// ストレージに追加
var saveStorage = function(Key,name,star){
  var Value = {name: name, star: star}; // オブジェクトを作る
  var setjson = JSON.stringify(Value); //JSON形式にエンコード
  if (Key && Value.name && Value) {
    localStorage.setItem(Key, setjson); //ストレージへ追加
  }
  Key = ''; Value = []; // 初期化  これでif(Value)に引っ掛かるのか心配
  viewStorage();
}

// スターの値を変える
var changeStar = function(id){
  var getjson = localStorage.getItem(id); // 受け取ったidの行を選択
  var obj = JSON.parse(getjson); // JSONをオブジェクトに（中身を見る為）
  if(obj.star == 0){var _star = 1} else{var _star = 0}  // スター変更
  var _id = id; // idそのまま
  var _name = obj.name; // 単語名そのまま
  saveStorage(_id,_name,_star); //あとは追加の時と同じ
}

// 特定のワードを削除
var removeStorage = function(id){
    //var id = document.getElementById("id").value;
    localStorage.removeItem(id);
    id = '';
    viewStorage();
};

// 全て削除
var clearStorage = function(){
    localStorage.clear();
    viewStorage();
};

// ユニークなIDを生成
function getUniqueStr(myStrong){
 var strong = 1000;
 if (myStrong) strong = myStrong;
 return new Date().getTime().toString(16)  + Math.floor(strong*Math.random()).toString(16)
}

// ローカルストレージのデータを表に出力
var viewStorage = function(){
    var tb = document.getElementById('tb')

    // テーブルの初期化
    while (tb.firstChild){
      tb.removeChild(tb.firstChild);
    }
    // }
    // テーブルの出力
    for (var i=localStorage.length-1; i>=0; i--) {
        var id = localStorage.key(i);
        var getjson = localStorage.getItem(id); 
        var obj = JSON.parse(getjson); // JSON → オブジェクト
        var name = obj.name;
        var star = obj.star;

        var tr = document.createElement('tr');
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var td3 = document.createElement('td');
        tb.appendChild(tr);
        tr.appendChild(td1);
        tr.appendChild(td2);
        tr.appendChild(td3);
        // スター  
        if(star == 0){var color='light'} else {var color='yellow'}
        td1.innerHTML = '<a onclick="changeStar(\'' + id + '\')" class="point '+ color +'"><i class="material-icons">star</i></a>';
        // 検索ワード
        td2.innerHTML = '<a href="https://www.google.com/search?q='+ name + '" target="_blank">' + name + '</a>'; 
        // ごみ箱
        td3.innerHTML = '<a onclick="removeStorage(\'' + id + '\')" class="point trash"><i class="material-icons">delete</i></a>';
    }
    // if(localStorage.length > 5){ // ストレージのデータが10個を超えたら
      // tr_long = document.createElement('tr').setAttribute("colspan", "3"); //エラー
      // tb.appendChild(tr_long); td_long = document.createElement('td'); tr_long.appendChild(td_long);

      // 全て削除のごみ箱
      // td_long.innerHTML = '<a onclick="clearStorage()">全て削除<i class="material-icons point trash">delete_forever</i></a>';
    // }
};
            
// window.onload = function() {
//     viewStorage();
    
    // 削除ボタンが押されたら実行
    // document.getElementById('clear').onclick = function() { 
        // clearStorage();
    // }; 
// };