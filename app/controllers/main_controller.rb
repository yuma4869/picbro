require "selenium-webdriver"
require 'resolv'
require 'pycall/import'

include PyCall::Import

PyCall.exec(<<PYTHON)
import yt_dlp
class Ytdl():
  def __init__(self,url,path):
    ydl = yt_dlp.YoutubeDL({
        "format": "best",
        "outtmpl": path + "%(title)s" + ".mp4"
    })
    result = ydl.download(url)
PYTHON

class MainController < ApplicationController
  skip_before_action :verify_authenticity_token #あきらめ

  def index
    normal_action()
  end

  def create #ブラウザ作成
    initBrowser(params[:width],params[:height])
    @file_path = "default"
    normal_action()
    render("main/index")
  end

  def tor_create
    tor_initBrowser(params[:width],params[:height])
    @file_path = "default"
    normal_action()
    render("main/index")
  end

  def rescreen_shot #スクリーンショット再取得
    screen_shot()
    normal_action()
    render("main/index")
  end

  def set_sleep(raw_sleep) #待機時間設定
    # 正規表現を定義する
    regex = /\A[+-]?\d+\.?\d*\z/

    # 正規表現にマッチするかどうかを確認する
    if regex.match(raw_sleep)
      @@sleep = params[:sleep].to_f
      @sleep = @@sleep
    else
      flash.now[:error] = ["待機時間が正しくありません","待機時間は正の実数を入力してください"]
    end
    normal_action()
  end

  def get_select #selectタグ取得
    source = @@driver.page_source
    @selects = source.gsub(/\n/, '').scan(/<select.*?>.*?<\/select>/)
    screen_shot()
    normal_action()
    render("main/index")
  end

  def scroll
    scroll = params[:scroll]
    begin
      @@driver.execute_script("window.scrollBy(0,#{scroll});") #javascriptでスクロールさせる
    rescue
      flash.now[:error] = ["Create Browser","ブラウザが作られていません。新しく作り直してください。"]
    end
    screen_shot()
    normal_action()
    render("main/index") 
  end

  def back #ひとつ前に戻る
    begin
      @@driver.navigate.back
    rescue
      flash.now[:error] = ["Create Browser","ブラウザが作られていません。新しく作り直してください。"]
      render("main/index")
    end
    screen_shot()
    normal_action()
    render("main/index")    
  end

  def next
    begin
      @@driver.navigate.forward
    rescue
      flash.now[:error] = ["Create Browser","ブラウザが作られていません。新しく作り直してください。"]
      render("main/index")
    end
    screen_shot()
    normal_action()
    render("main/index") 
  end

  def tab_move #別のタブを開く、ドライバーのカレントタブを設定
    tab_index = params[:index].to_i
    begin
      @@driver.switch_to.window(@@driver.window_handles[tab_index])
    rescue => e
      puts e  
    end
    screen_shot()
    normal_action()
    render("main/index")
  end

  def tab_rm #タブ削除
    tab_index = params[:index].to_i
    puts tab_index
    begin
      @@driver.switch_to.window(@@driver.window_handles[tab_index])
      @@driver.close
      last_window = @@driver.window_handles.last
      @@driver.switch_to.window(last_window)
    rescue => e
      puts e  
    end
    normal_action()
    screen_shot()
    render("main/index")
  end

  def tab_create
    @@driver.switch_to.new_window(:tab)
    @@driver.get("https://google.com")
    normal_action()
    screen_shot()
    render("main/index")  
  end
  
  def click_hold #クリック＆ホールド、スクロールバーをマウスで移動させるときのようなやつ
    one_x = params[:one_x].to_i
    one_y = params[:one_y].to_i
    two_x = params[:two_x].to_i - one_x #move_byで相対位置で動くから差を求める
    two_y = params[:two_y].to_i - one_y

    puts one_x
    puts one_y
    puts two_x
    puts two_y

    begin
      @@driver.action.move_by(one_x, one_y).click_and_hold.move_by(two_x, two_y).perform
    rescue
      @@driver.action.move_by(one_x-2, one_y-2).click_and_hold.move_by(two_x-2, two_y-2).perform
    end
    screen_shot()
    normal_action()
    render("main/index")
  end

  
  def video
    source = @@driver.page_source #ページのソースから、videoタグがあるかを探す
    videos = source.gsub(/\n/, '').scan(/<video.*?>.*?<\/video>/)
    if videos.length > 0
      title = @@driver.title
      videos.each do |video|
        @@video_path.push({"video" => video,"title" => title})
      end
    else
      flash.now[:info] = ["No such videos","このページ内に動画はありませんでした"]
    end
    screen_shot()
    normal_action()
    render("main/index")    
  end


  def youtube_video
    current_url = @@driver.current_url #現在のURLを取得
    if current_url.include?("https://www.youtube.com/watch?v=") || current_url.include?("https://www.nicovideo.jp/watch/") #現在のＵＲＬがyoutubeかniconico

      #PyCallを使用して、yt-dlpを呼び出し、youtube動画などをランダムなパスにダウンロード
      random_path = random_string(3)
      video_path = "public/videos/" + random_path


      
      ytdl = PyCall.eval('Ytdl').(current_url,video_path)
      

      video_paths = get_files_with_string("public/videos/",random_path)
      video_paths.each do |video_path|
        pre_title = video_path[40..] #めっちゃむりやりに、動画のタイトルを取得
        title = pre_title[..-5]
        @@video_path.push({"youtube" => video_path,"title" => title})
      end
    else
      flash.now[:warning] = ["利用方法を確認してください","youtubeの動画を開いた状態で押してください。"]
    end
    screen_shot()
    normal_action()
    render("main/index")
  end

  def page
    ip_addr_str = Resolv::DNS.new(:nameserver=>'ns1.google.com').getresources("o-o.myaddr.l.google.com", Resolv::DNS::Resource::IN::TXT)[0].strings[0] #悪用防止のため、一応データベースに保存、公開を宣言するときは、きちんとIPを集める旨を伝えたり、別の方法にする
    input_log = Input.new(ip: ip_addr_str,url: params[:url])
    begin input_log.save!
    rescue
      logger.error "タスクの保存に失敗しました。エラーメッセージ：#{e.message}"
    end

    set_sleep(params[:sleep])
    get_page(params[:url])
    normal_action()
    redirect_to("/browser")
  end

  def click
    click_page(params[:x].to_i,params[:y].to_i)
    normal_action()
    render("main/index")
  end

  def text
    cur_url = @@driver.current_url
    ip_addr_str = Resolv::DNS.new(:nameserver=>'ns1.google.com').getresources("o-o.myaddr.l.google.com", Resolv::DNS::Resource::IN::TXT)[0].strings[0]
    input_log = Input.new(ip: ip_addr_str,url: cur_url,text: params[:text])
    begin input_log.save!
    rescue
      logger.error "タスクの保存に失敗しました。エラーメッセージ：#{e.message}"
    end
    input_page(params[:x].to_i,params[:y].to_i,params[:text])
    normal_action()
    render("main/index")
  end

  def initBrowser(width,height)
    #@@driverがあるか確認、回りくどいが動けばOK
    begin
      @@driver.nil?
      @@driver.quit
    rescue
      puts "driverはないようです"
    end
    
    @@video_path = []
    chromedriver_path = File.expand_path('../chromedriver.exe', __FILE__)
    Selenium::WebDriver::Chrome::Service.driver_path="C:\\Users\\tttyy\\Downloads\\chromedriver-win64\\chromedriver-win64\\chromedriver.exe" #ローカル用
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--window-size=#{width},#{height}")
    options.add_argument("--mute-audio")
    options.add_argument('--log-level=1')
    @@driver = Selenium::WebDriver.for :chrome , options: options
    @wait = Selenium::WebDriver::Wait.new(:timeout => 100)

    @@other_information = "normalBrowser"
  end

  def tor_initBrowser(width,height)
    begin
      @@driver.nil?
      @@driver.quit
    rescue
      puts "driverはないようです"
    end
    
    @@video_path = []

    
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--proxy-server=socks5://localhost:9150") #windowsテスト環境用、torBrowserを開いて、接続をしたらseleniumで起動できる
    options.add_argument('--headless')
    options.add_argument('--start-maximized')
    options.add_argument('--disable-blink-features')
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument('--disable-browser-side-navigation')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-extensions')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-infobars')
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--ignore-ssl-errors')
    options.add_argument('--no-sandbox')
    options.add_argument("--mute-audio")
    options.add_argument('--log-level=1')
    options.add_argument("--window-size=#{width},#{height}")

    @@driver = Selenium::WebDriver.for :chrome , options: options
    @wait = Selenium::WebDriver::Wait.new(:timeout => 100)

    @@other_information = "torBrowser"
  end

  def get_page(url)
      @@sleep ||= 0.5
      @@driver.get(url)
      sleep @@sleep
      screen_shot()
  end

  def click_page(x,y)
    @@sleep ||= 0.5
    @@driver.action.move_to_location(x,y).click.perform
    sleep @@sleep
    screen_shot()
  end

  def for_click_page(x,y,count)
    @@sleep ||= 0.5
    count -= 1
    for i in 0..count do
      @@driver.action.move_to_location(x[i].to_i,y[i].to_i).click.perform
      sleep @@sleep
    end
    screen_shot()
  end

  def input_page(x,y,text)
    @@sleep ||= 0.5
    @@driver.action.move_to_location(x,y).click.send_keys(text).perform
    sleep @@sleep
    screen_shot()
  end

  private

  def normal_action  #なんかもっといい方法ありそう、これでやってるのは、@sleepとかで、index.html.erbに待機時間表示させたいから、クラス変数をインスタンス変数に変換している
    instance_sleep()
    instance_video()
    tab_check()
    other_information()
  end

  def screen_shot
    begin
      @file_path = random_string(5)
      @@driver.save_screenshot("public/images/#{@file_path}.png")
    rescue => e
      puts e
    end
  end

  def instance_sleep

    begin
      @sleep = @@sleep
    rescue
      @sleep = 0.5
    end
  end

  def instance_video
    begin
      @video_path = @@video_path
    rescue

    end
  end

  def tab_check
    begin
      @tab_titles = []
      @@tab_index = @@driver.window_handles.index(@@driver.window_handle)
      @tab_index = @@tab_index

      total = @@driver.window_handles.length.to_i
      for i in 0..total - 1
        @@driver.switch_to.window(@@driver.window_handles[i])
        @tab_titles.push(@@driver.title)
      end
      @@driver.switch_to.window(@@driver.window_handles[@tab_index])

      @total_tab = total - @tab_index
    rescue => e
      puts e
    end
  end

  def other_information
    begin
      @other_information = @@other_information
    rescue

    end
  end

  def get_files_with_string(folder_path, string)
    files = Dir.glob(File.join(folder_path, "*")) #ランダムなファイルパス生成
    result = []
    files.each do |file_path|
      if file_path.include?(string)
        result.push(file_path)
      end
    end
    return result
  end

  def random_string(n)
    time = Time.now.strftime("%Y%m%d%H%M%S%N")
    chars = ("0".."9").to_a.join + ("A".."Z").to_a.join + ("a".."z").to_a.join
    result = (Array.new(n).map! {|e| chars[rand(chars.length)]}).join
    return result + time
  end
end
