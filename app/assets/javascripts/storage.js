// ローカルストレージのデータを表に出力する関数
var viewStorage = function(){
  var tb = document.getElementById('tb') // tbody

  // テーブルの初期化
  while (tb.firstChild){ tb.removeChild(tb.firstChild) }

  // テーブルの出力
  for (var i=localStorage.length-1; i>=0; i--) {

    var id = localStorage.key(i);
    var getjson = localStorage.getItem(id); 
    var obj = JSON.parse(getjson); // JSON → オブジェクト


    // 行
    var tr = document.createElement('tr');  
    tr.classList.add('row'); 
    tb.appendChild(tr);


    //// New
    var td1 = document.createElement('td');
    td1.classList.add('d-none', 'd-sm-block', 'col-2', 'col-lg-1');
    tr.appendChild(td1);

    if(obj.visit == 0){var deco='NEW'} else {var deco=''}
    td1.innerHTML = '<div class="new">' + deco; + '</div>'


    //// 検索ワード
    var td2 = document.createElement('td'); 
    td2.classList.add('col-9', 'col-sm-8', 'col-lg-9', 'word');
    tr.appendChild(td2);

    // サイトURLをセット（Google・Youtube・Twitter）
    if(session == 'Google'){
      site_url = 'https://www.google.com/search?q=' 
    }else if(session == 'Youtube'){
      site_url = 'https://www.youtube.com/results?search_query=' 
    }else if(session == 'Twitter'){
      site_url = 'https://twitter.com/search?q=' 
    }

    td2.innerHTML = '<a onclick="changeStorage(\'' + id + '\',\'visit\')" href="'+ site_url +''+ obj.name + '" target="_blank" class="d-block">' + obj.name + '</a>'; 


    //// スター
    var td3 = document.createElement('td'); 
    td3.classList.add('col-1_half', 'col-sm-1');
    tr.appendChild(td3);

    if(obj.star == 0){var color='nostar'} else {var color='star'}
    td3.innerHTML = '<a onclick="changeStorage(\'' + id + '\',\'star\')" class=" '+ color +'"><i class="material-icons">star</i></a>';


    //// ごみ箱
    var td4 = document.createElement('td'); 
    td4.classList.add('col-1_half', 'col-sm-1');
    tr.appendChild(td4);

    td4.innerHTML = '<a onclick="removeStorage(\'' + id + '\')" class="trash"><i class="material-icons">delete</i></a>';
  }
}
      


// 新しいワード追加ボタンを押されたとき
// $('#get_word').on('click', function getWord() { // oneだから1回だけ有効
var makeWord = function(){

  // リクエストを送信
  $.ajax({
      url : '/add', // ランダムワード生成してrenderしてくれるcontrollerを叩く
      type : 'GET',
      dataType:'html', 
      // data : {}, // 今回は、受け取るだけでこちらからは何も送らない

      beforeSend: function(){ // 通信中
        document.getElementById('make_word').innerHTML = '<i class="fa fa-spinner fa-spin"></i>　ワード 生成中　<i class="fa fa-spinner fa-spin"></i>' // loadingマーク
      },

      error : function(XMLHttpRequest, textStatus, errorThrown) { // エラーの場合
        console.log('ajax通信に失敗しました');
        // console.log('XMLHttpRequest : ' + XMLHttpRequest.status);
        // console.log('textStatus     : ' + textStatus);
        // console.log('errorThrown    : ' + errorThrown.message);          
      },
      success : function(response) { // 成功の場合
        console.log('ajax通信に成功しました');
        console.log(response);

        // ストレージに保存する値をセット
        uuid = getUniqueStr(); // ユニークなIDを取得　
        var Key = 'randomMemo_'+uuid; // このサイト特有の文字列を組み合わせる
        var _name = response; // topのviewでセットしたワード
        var _star = 0; // 始めはスターなし
        var _visit = 0; // 始めは訪れてない
        saveStorage(Key, _name, _star, _visit); 

      }

  }).done(function(data) { // その後の処理
    document.getElementById('make_word').innerHTML = 'ランダムワード生成 ＋' // ボタンの文字を元に戻しておく
  });


}
// });


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

// ページ読み込み完了時 
window.onload = function() {
    viewStorage();
}

//= require rails-ujs
//= require activestorage
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .