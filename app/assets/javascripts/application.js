var getWord = function(){  

  // ローカルストレージに保存する要素をセット
  uuid = getUniqueStr(); // ユニークなIDを取得　
  var Key = 'randomMemo_'+uuid; // このサイト特有の文字列を組み合わせる
  var _name = word; // topのviewでセットしたワード
  var _star = 0; // 始めはスターなし
  var _visit = 0; // 始めは訪れてない
  saveStorage(Key,_name,_star,_visit); 
  $('#add_button').removeEventListener('onclick');
}


// ストレージに追加
var saveStorage = function(Key,name,star,visit){
  var Value = {name: name, star: star, visit: visit}; // オブジェクトを作る
  var setjson = JSON.stringify(Value); //JSON形式にエンコード
  if (Key && Value.name && Value) {
    localStorage.setItem(Key, setjson); //ストレージへ追加
  }
  Key = ''; Value = []; // 初期化  これでif(Value)に引っ掛かるのか心配
  viewStorage();
}


// ストレージの値を更新
var changeStorage = function(id, purpose){
  var getjson = localStorage.getItem(id); // 受け取ったidの行を選択
  var obj = JSON.parse(getjson); // JSONをオブジェクトに（中身を見る為）
  var _id = id; // id
  var _name = obj.name; // 単語名
  var _star = obj.star; // スター
  var _visit = obj.visit; // 訪問

  if(purpose == 'star'){ // スター目的の場合
    if(obj.star == 0){_star = 1} else{_star = 0}  // スター変更
  }
  if(purpose == 'visit'){ // 訪問チェック目的の場合
    _visit = 1
  }
  saveStorage(_id, _name, _star, _visit); //あとは追加の時と同じ
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

  // テーブルの出力
  for (var i=localStorage.length-1; i>=0; i--) {
    var id = localStorage.key(i);
    var getjson = localStorage.getItem(id); 
    var obj = JSON.parse(getjson); // JSON → オブジェクト
    var name = obj.name;
    var star = obj.star;
    var visit = obj.visit;

    var tr = document.createElement('tr'); // 行 
    // tr.classList.add('justify-content-between'); //テーブルの列を両端から均等に並べる
    // tr.classList.add('table-info'); // 行に背景色指定

    var td1 = document.createElement('td'); // 訪問チェック
    td1.classList.add('col-0'); // 列幅調整

    var td2 = document.createElement('td'); // 検索ワード
    td2.classList.add('col-8'); // 列幅調整
    td2.classList.add('word'); // 単語には特徴のあるCSSを付けたい
    // td2.classList.add('text-center'); // 真ん中揃え？？

    var td3 = document.createElement('td'); // スター
    td3.classList.add('col-1'); // 列幅調整

    var td4 = document.createElement('td'); // ごみ箱
    td4.classList.add('col-1'); // 列幅調整

    tb.appendChild(tr);
    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);

    // New
    if(visit == 0){var deco='NEW'} else {var deco=''}
    td1.innerHTML = '<div class="text-danger new">' + deco; + '</div>'

    // 検索ワード
    td2.innerHTML = '<a onclick="changeStorage(\'' + id + '\',\'visit\')" href="https://www.google.com/search?q='+ name + '" target="_blank" class="d-block">' + name + '</a>'; 

    // スター  
    if(star == 0){var color='nostar'} else {var color='star'}
    td3.innerHTML = '<a onclick="changeStorage(\'' + id + '\',\'star\')" class=" '+ color +'"><i class="material-icons">star</i></a>';

    // ごみ箱
    td4.innerHTML = '<a onclick="removeStorage(\'' + id + '\')" class="trash"><i class="material-icons">delete</i></a>';
  }
  
    // if(localStorage.length > 5){ // ストレージのデータが10個を超えたら
      // tr_long = document.createElement('tr').setAttribute("colspan", "3"); //エラー
      // tb.appendChild(tr_long); td_long = document.createElement('td'); tr_long.appendChild(td_long);

      // 全て削除のごみ箱
      // td_long.innerHTML = '<a onclick="clearStorage()">全て削除<i class="material-icons point trash">delete_forever</i></a>';
    // }
};
            
window.onload = function() {
    viewStorage();
    
    // 削除ボタンが押されたら実行 // これいる？？？
    // document.getElementById('clear').onclick = function() { 
    //     clearStorage();
    // }; 
};



//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .