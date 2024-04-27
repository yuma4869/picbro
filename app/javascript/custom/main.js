


//右クリックとかで連続クリックのやつ再現したい、右クリック一回目のところに薄い赤丸おいてその横に1 2 とか書いて-->
$(document).on('turbolinks:load', function() {
    alert("kasu");
    // 処理内容
  });

    function getStyle(element_id,style_name){
        let element = document.getElementById(element_id);
        let style = window.getComputedStyle(element);
        let value = style.getPropertyValue(style_name);
        return value;
    }

    //sleep整数チェック
    function checkSleep() {
        let sleep = document.getElementById("sleep").value;
        let regex = /^([+-]?\d+)(?:\.\d+)?$/;
        if (regex.test(sleep)){
            let error = document.getElementById("error");
            error.innerText = "";
            error.style.display = "none";
        }else{
            var error = document.getElementById("error");
            error.innerText = "待機時間には実数を必ず入力してください";
            error.style.display = "block";
        }
    }

    //何番目のビデオボタンが押されたか

    function butotnClick(){
        let textbox = document.getElementById('url');
        let value = textbox.value;
        let url = encodeURIComponent(value);

        window.location.href = "http://localhost:3000/browser/" + url;
    }

    function createBrowser() {
        console.log("hi");
        let width = document.getElementById("imgbox").clientWidth;
        let height = document.getElementById("imgbox").clientHeight;
        window.location.href = "http://localhost:3000/browser/create?width=" + width + "&height=" + height;
    }

    function clickAndHold() {
        let one_hold_value = getStyle("one","display");
        let two_hold_value = getStyle("two","display");
        let one_x = getStyle("one","left").replace("px","");
        let one_y = getStyle("one","top").replace("px","");
        let two_x = getStyle("two","left").replace("px","");
        let two_y = getStyle("two","top").replace("px","");

        if(one_hold_value == "block" && two_hold_value == "block"){
            window.location.href = "http://localhost:3000/browser/click_hold/" + one_x + "/" + one_y + "/" + two_x + "/" + two_y;
        }
    }

    function blockYoutube() {
        let youtube = document.getElementById("video");
        if (getStyle("video","display") == "none"){
            youtube.style.display = "block"
        }else{
            youtube.style.display = "none"
        }
    }


    var urlSubmitButton = document.getElementById('submitButton');
    urlSubmitButton.addEventListener('click', butotnClick);

    var createButton = document.getElementById("createButton");
    createButton.addEventListener("click", createBrowser);

    var holdButton = document.getElementById("holdButton");
    holdButton.addEventListener("click",clickAndHold);

    // var videoButton = document.getElementById("video_button");#mount_0_0_kx > div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > section > main > div._aa6b._ad9f._aa6d > div._aa6e > article > div > div.x9f619.xjbqb8w.x78zum5.x168nmei.x13lgxp2.x5pf9jr.xo71vjh.x1n2onr6.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > div > div._ae5q._akdn > ul > div:nth-child(3) > div > div > div:nth-child(3) > ul > div > li > div > div > div._a9zr > div._a9zs > span
    // videoButton.addEventListener("click",blockYoutube);
    var box_videos = document.querySelectorAll("#video");
                var imgbox = document.getElementById("imgbox");

    box_videos.forEach((video) => {
        imgbox.insertBefore(video,imgbox.firstChild);
    });


            var elms = document.querySelectorAll('#video_button');
    var index;// クリックした要素のインデックスを格納する変数
    elms.forEach((elm) => {// elementsを持つ要素すべてに以下の処理を追加する
    elm.addEventListener("click", () => {// クリックしたときに
        index = [].slice.call(elms).indexOf(elm);// インデックスを変数indexへ格納する
        console.log('順番',index);//変数「i」に順番が入っている（0スタート）
        let path = `#imgbox > div:nth-child(${index + 1})`;
        console.log(path);
        let action_video = document.querySelector(path);
        action_video.classList.toggle("block");
        path = `#videos > button:nth-child(${index + 1})`;
        let button = document.querySelector(path);
        button.classList.toggle("active");
    });
    });




    //画像クリックされた位置の座標送る-->

    document.getElementById( "img" ).addEventListener( "click", function( event ) {
    var click_x = event.pageX ;
    var click_y = event.pageY ;

    // 要素の位置を取得
    var client_rect = this.getBoundingClientRect() ;
    var position_x = client_rect.left + window.pageXOffset ;
    var position_y = client_rect.top + window.pageYOffset ;

    // 要素内におけるクリック位置を計算
    var x = Math.round(click_x - position_x );
    var y = Math.round(click_y - position_y );

    // 入力するテキストがあるかどうか確認
    var input_text = document.getElementById("text").value;
    if (input_text){
        window.location.href = "http://localhost:3000/browser/" + x + "/" + y + "/" + input_text;

    } else {
        window.location.href = "http://localhost:3000/browser/" + x + "/" + y;
    }


} ) ;

//スクロール検知-->

//厳密にはマウスホイール検知
//いちいち止まらなあかんのだるいから、スクロールした回数をpxに変換してその分一気にスクロールする
// window.onmousewheel = function(){
//     if(event.wheelDelta > 0){
//         window.location.href = "http://localhost:3000/browser/scrollup";
//     }else{
//         window.location.href = "http://localhost:3000/browser/scrolldown";
//     }
// }
var box = document.getElementById("imgbox");

var innerimg = document.getElementById("innerimg");
innerimg.style.height = box.clientHeight;

var scroll = 0;
var scroll_flag = 0;
    var a = document.getElementById("img").getBoundingClientRect().top;
    console.log("sd"+a);
    var elm = document.getElementById("imgbox");
    console.log("ssss");
    elm.scrollTop = 1032;
    console.log("ffff");

        function init_scroll() {
    var a = document.getElementById("img").getBoundingClientRect().top;
    console.log("sd"+a);
    var elm = document.getElementById("imgbox");
    console.log("ssss");
    elm.scrollTop = 1032;
    console.log("ffff");
}

function noscroll(e){
e.preventDefault();
}
box.onscroll = function() {
    scroll = $(this).scrollTop() - 1032;
    console.log("sdfs"+scroll);
    if(scroll >= 0){
        document.getElementById("now_scrollup").innerText = "";
        document.getElementById("now_scrolldown").innerText = scroll;
    }else{
        document.getElementById("now_scrolldown").innerText = "";
        document.getElementById("now_scrollup").innerText = scroll;
    }
}
box.onscrollend = (event) => {
    console.log("aaadfg"+scroll);
    if(Math.abs(scroll) >= 100){
        window.location.href = "http://localhost:3000/browser/scroll/" + scroll;
        scroll_flag = 1;
        console.log(scroll_flag);
    }
};
function sleep(waitMsec) {
var startMsec = new Date();

// 指定ミリ秒間だけループさせる（CPUは常にビジー状態）
while (new Date() - startMsec < waitMsec);
}
// window.onload = function() {
//     sleep(100);
//     init_scroll();
// }
if(scroll_flag == 1){console.log("aa");init_scroll();}


//特定の文字を押された際に特定の動作をする-->

var keyArr = []
var img_mouse_flag = false;
var hold_count = 0;

var hold_x = 0;
var hold_y = 0;

function onKeyDown(e) {
    console.log(e);
    if(String(e.code) == "Backspace" && hold_count != 0 && img_mouse_flag == true){
        var id = hold_count == 2 ? "one" : "two";
        var element = document.getElementById(id);
        element.style.display = "none";
        var element_hold = document.getElementById(id + "_hold");
        element_hold.style.opacity = 0.5;
        hold_count = id == "one" ? 1 : 2; //3回とか押したら２だけが表示されるようなことが起きるけど動いたらヨシ!!
    }
    if(String(e.code) == "KeyM" && img_mouse_flag == true ){


        if(hold_count <= 1){
            var one = document.getElementById("one");
            one.style.display = "block";
            one.style.position = "absolute";
            one.style.left = hold_x + "px";
            one.style.top = hold_y + "px";
            var one_hold = document.getElementById("one_hold");
            one_hold.style.opacity = 1;
            hold_count += 2;
            console.log(hold_count);
        }else{
            var two = document.getElementById("two");
            two.style.display = "block";
            two.style.position = "absolute";
            two.style.left = hold_x + "px";
            two.style.top = hold_y + "px";
            var two_hold = document.getElementById("two_hold");
            two_hold.style.opacity = 1;
            hold_count = 1;
        }
    }
    keyArr.push(e.code)
    if (keyArr.length > 10) {
        keyArr.shift()
    }
    var konamiCommand = [
        'ArrowUp',
        'ArrowUp',
        'ArrowDown',
        'ArrowDown',
        'ArrowLeft',
        'ArrowRight',
        'ArrowLeft',
        'ArrowRight',
        'KeyB',
        'KeyA',
    ]
    console.log(keyArr)

    if (String(keyArr) === String(konamiCommand)) {
        console.log("できた！")
    }
}
console.log("hello");
// img = document.getElementById("img");
document.addEventListener('keydown', onKeyDown);

document.onmousemove = onmousemove;
onmousemove = function(e) {
    var click_x = event.pageX ;
    var click_y = event.pageY ;

    // 要素の位置を取得
    var client_rect = document.getElementById("img").getBoundingClientRect() ;
    var position_x = client_rect.left + window.pageXOffset ;
    var position_y = client_rect.top + window.pageYOffset ;

    // 要素内におけるクリック位置を計算
    hold_x = click_x - position_x ;
    hold_y = click_y - position_y ;
}

//マスポインタがimg上にあるかどうか
document.getElementById("img").addEventListener("mouseout",function(){
    img_mouse_flag = false;
    console.log("mouseout");
})
document.getElementById("img").addEventListener("mouseover",function(){
    img_mouse_flag = true;
    console.log("mouseover");
})



$(function(){
    $('.btn-trigger').on('click', function() {
        $(this).toggleClass('active');
        $("#menu_list").toggleClass("active");
        return false;
    });
});


//     var menu = document.getElementById("menu");
// var active_menu = menu.className;
// console.log(active_menu);
// if (active_menu.includes("active")){
//     var menu_list = document.getElementById("menu_list");
//     menu_list.style.display = "block";
// }

//はみ出てるボタン検知-->

function tab_protrude(allEls) {
    var tab_width = document.getElementById("tab").getBoundingClientRect().right;
    var i = 0;
    allEls.forEach(el => {
        i += 1;
        var right = el.getBoundingClientRect().right;
        console.log(right);
        if(right + 15 > tab_width) {
            console.log(right);
            console.log(tab_width);
            console.log(i);
            console.log("slkrjghslkjghserhys");
            return i;
        }
    });
    return false
}

function main_tab_check() {
    var element = document.querySelector(".tab_create").getBoundingClientRect().right;
    var tab_width = document.getElementById("tab").getBoundingClientRect().right;
    if ( element + 15 > tab_width ){
        var allEls = document.querySelectorAll(".tab_rm");
        var tab_r = tab_protrude(allEls);
        if (tab_r == false){
            document.getElementById("")
        }
        //新しいタブ作成ボタンはみ出てるけどメインのタブがはみ出てなかったら最後の要素だけはみ出てる判定にする
    }else{
        //新しいタブ作成ボタンがはみ出てない=ビデオボタンだけはみ出てる。
    }
}

if (document.querySelector(".btn") != null){//ビデオボタンがあるか
    var allEls = document.querySelectorAll('.btn');
    var r = tab_protrude(allEls);
    if ( r != false ){//ビデオボタンがはみ出てる

    }
}
    var widths = 0;

