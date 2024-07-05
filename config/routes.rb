Rails.application.routes.draw do
  get '/' => "welcome#top"

  get "/test" => "welcome#test"

  post "/test/post" => "welcome#test_post"
  
  get '/browser' => "main#index"

  #ブラウザー作成
  get "browser/create" => "main#create"
  #tor
  get "browser/tor-create" => "main#tor_create"

  #アクセス
  post "browser/access" => "main#page"

  #スクロール
  get "browser/scroll/:scroll" => "main#scroll"

  #スクリーンショット再取得
  get "browser/screen-shot" => "main#rescreen_shot"

  #select取得
  get "browser/select" => "main#get_select"

  #待機時間設定
  post "browser/sleep" => "main#set_sleep"

  #戻る&進む
  get "browser/prev" => "main#back"
  get "browser/next" => "main#next"

  #タブ移動
  get "browser/tab-move" => "main#tab_move"

  #タブ削除
  get "browser/tab-rm" => "main#tab_rm"

  #新しいタブ作成
  get "browser/tab-create" => "main#tab_create"

  #クリック&ホールド
  get "browser/click-hold/:one_x/:one_y/:two_x/:two_y" => "main#click_hold"

  #ページ内の動画取得
  get "browser/video" => "main#video"

  #youtubeの動画取得
  get "browser/youtube-video" => "main#youtube_video"

  #アクセス
  # get "browser/:url" => "main#page",constraints: { url: /[^\/]+/ }

  #クリック
  get "browser/:x/:y" => "main#click" #今は別にいらんからパスにURL入れてないけどapiとか後々作るときはURLとクリック座標指定してpng返すみたいにする

  #クリックしてテキスト送信
  get "browser/:x/:y/:text" => "main#text"

  #多数クリック&テキスト送信    べつにいらんなおもったため実装取り消し
  #match "browser/*params" => "main#for_click",:via => :get 
end
