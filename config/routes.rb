Rails.application.routes.draw do
  get '/' => "main#index"

  #ブラウザー作成
  get "browser/create" => "main#create"

  #スクロール
  get "browser/scrolldown" => "main#scroll_down"
  get "browser/scrollup" => "main#scroll_up"

  #スクリーンショット再取得
  get "browser/screen_shot" => "main#rescreen_shot"

  #select取得
  get "browser/select" => "main#get_select"

  #待機時間設定
  post "browser/sleep" => "main#set_sleep"

  #戻る&進む
  get "browser/back" => "main#back"
  get "browser/next" => "main#next"

  #アクセス
  get "browser/:url" => "main#page",constraints: { url: /[^\/]+/ }

  #クリック
  get "browser/:x/:y" => "main#click" #今は別にいらんからパスにURL入れてないけどapiとか後々作るときはURLとクリック座標指定してpng返すみたいにする

  #クリックしてテキスト送信
  get "browser/:x/:y/:text" => "main#text"

  #多数クリック&テキスト送信
  match "browser/*params" => "main#for_click",:via => :get
end
