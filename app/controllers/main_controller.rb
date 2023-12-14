require "selenium-webdriver"

class MainController < ApplicationController
  before_action :instance_sleep,only:[:index,:create,:rescreen_shot,:get_select,:scroll_down,:scroll_up,:back,:next,:for_click,:page,:click,:text] #renderを最後つかうやつ

  #####やることリスト#########
  #テキスト入力を例えば「t」をおしたら現在のカーソルの横に入力欄が出てそこで入力して簡単にテキストを指定できる
  #ビデオ再生（一番の目的はyoutube)
  #:済　ロードが長いのとかように待機時間指定
  #ブラウザとかを再現するUIデザインをプロに任せる？時間あったら自分でやる
  #https://qiita.com/mochio/items/dc9935ee607895420186 この記事にあるやつだいたい再現する
  #横向きのスクロール
  #連続クリックのポインター
  #selectタグ
  #お気に入りとか閲覧履歴とか記録したい無料でデバイス記録してcookieで閲覧履歴保存するかログインして閲覧履歴保存してもらうかは未定
  #LINEとかもできるように
  #https以外でもアクセスできるように
  #プロセカの最初のやつみたいに、上に、「selectはselectボタンを押そう」「テキスト入力はTをクリック！」「ロードが続いているときはスクリーンショット再取得ボタンをおす！（バックグラウンドでブラウザは起動しているからもうロードは終わってるはずだから）」みたいなのを上部に表示して回す。クリックしたら次のメッセージ表示
  #クリック&ホールドで「s」おして一回目のクリックしたところの横に1、その次にクリックしたところを2と表示して、1から2にクリック&ホールドしてこれ応用してスクロールバー動かしたりする
  #ファイルアップロードとかはpicture_browserの意義に反するから実装しないかも？

  def index
    @file_path = "default"
  end

  def create
    initBrowser(params[:width],params[:height])
    @file_path = "default"
    render("main/index")
  end

  def rescreen_shot #スクリーンショット再取得
    screen_shot()
    render("main/index")
  end

  def set_sleep
    # 正規表現を定義する
    regex = /\A[+-]?\d+\.?\d*\z/

    # 正規表現にマッチするかどうかを確認する
    if regex.match(params[:sleep])
      @@sleep = params[:sleep].to_f
      puts @@sleep
      @sleep = @@sleep
      puts @sleep
    else
      flash[:notice] = "待機時間は正の実数を入力してください"
    end
    puts @sleep
    redirect_to ("/")
  end

  def get_select
    source = @@driver.page_source
    puts source
    @selects = source.gsub(/\n/, '').scan(/<select.*?>.*?<\/select>/)
    screen_shot()
    render("main/index")
  end

  #ToDo
  #スクロール、やけど、インスタのフォロワーのところのスクロールみたいに一部しか出金みたいなところはまだ試してないけど、クリックホールドでスクロールバー動かす
  #インスタのやつとかはlocation_once_scrolled_into_view使ったらいいかも？試してないけど
  def scroll_down
    begin
      @@driver.execute_script('window.scrollBy(0,500);')
    rescue
      flash.now[:alert] = "ブラウザが作られていません。新しく作り直してください。"
    end
    screen_shot()
    render("main/index")
  end

  def scroll_up
    begin
      @@driver.execute_script('window.scrollBy(0,-500);')
    rescue
      flash.now[:alert] = "ブラウザが作られていません。新しく作り直してください。"
    end
    screen_shot()
    render("main/index")
  end

  def back
    begin
      @@driver.navigate.back
    rescue
      flash.now[:alert] = "ブラウザが作られていません。新しく作り直してください。"
    end
    screen_shot()
    render("main/index")    
  end

  def next
    begin
      @@driver.navigate.forward
    rescue
      flash.now[:alert] = "ブラウザが作られていません。新しく作り直してください。"
    end
    screen_shot()
    render("main/index")    
  end

  def for_click
    #ToDo:selectのところテキスト入力したらいいと言ってたけど、selectどんな項目あるか結局スクロールできな意味ないので、結局ソースからoptionタグ探すことになりそう
    puts "成功"
    param = params[:params] #変数名思いつかん、これが実務経験なしの独学のデメリット
    vector = param.split("/")
    count = vector.size
    x = []
    y = []
    if count % 2 == 0
      #select 対策とかで連続してクリックできるようにして、それで最後にtextがついてたら奇数になるからそれの判定
      #select対策は普通にテキスト入力でできることが判明
      vector.each_with_index { |first, second| second.even? ? x << first : y << first }
      puts "#{vector}::#{x}::#{y}"
      for_click_page(x,y,count/2)
    else
      text = vector.pop
      vector.each_with_index { |first, second| second.even? ? x << first : y << first }
      for_input_page(x,y,text,count/2)
    end
    render("main/index")
  end

  def page
    get_page(params[:url])
    render("main/index")
  end

  def click
    click_page(params[:x].to_i,params[:y].to_i)
    render("main/index")
  end

  def text
    input_page(params[:x].to_i,params[:y].to_i,params[:text])
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

    options = Selenium::WebDriver::Chrome::Options.new
    puts 1
    options.add_argument('--headless')
    puts 2
    options.add_argument("--window-size=#{width},#{height}")
    puts 3
    @@driver = Selenium::WebDriver.for :chrome , options: options
    puts 4
    @wait = Selenium::WebDriver::Wait.new(:timeout => 100)
    puts 5

  end

  #実装するときはスクリーンショットのところとか関数化したり、結構重なってるところとかあるからやめたり、begin とか使ったりする

  def get_page(url)
      @@sleep ||= 0.5
      puts @@sleep
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

  def for_input_page(x,y,text,count)
    @@sleep ||= 0.5
    count -= 1
    for i in 0..count
      if i == count
        @@driver.action.move_to_location(x[i].to_i,y[i].to_i).click.send_keys(text).perform
        sleep @@sleep
      else
        @@driver.action.move_to_location(x[i].to_i,y[i].to_i).click.perform
        sleep @@sleep
      end
    end
    screen_shot()
  end

  private

  def screen_shot
    @file_path = random_string(5)
    @@driver.save_screenshot("public/images/#{@file_path}.png")
  end

  def instance_sleep
    begin
      @sleep = @@sleep
    rescue
      @sleep = 0.5
    end
  end

  def random_string(n)
    time = Time.now.strftime("%Y%m%d%H%M%S%N")
    chars = ("0".."9").to_a.join + ("A".."Z").to_a.join + ("a".."z").to_a.join
    result = (Array.new(n).map! {|e| chars[rand(chars.length)]}).join
    return result + time
  end
end
