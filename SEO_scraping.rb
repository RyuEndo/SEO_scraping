require 'nokogiri'
require 'open-uri'
require 'pry-rails'
require 'pry-byebug'
require 'google_drive'


 def one
   # config.jsonを読み込んでセッションを確立
  session = GoogleDrive::Session.from_config("config.json")

  user_agent ="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.80 Safari/537.36"

# スプレッドシートをURLで取得
  sp=session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1SuTd7sJ8p46f1ptt8fnA-7lFJ2p1IYYErvE2kTTXQYc/edit#gid=0")

# "シート21"という名前のワークシートを取得
  ws = sp.worksheet_by_title("26")

# C3からクエリをとってきて検索窓のURLを取得
  @index_host = "https://www.google.co.jp/search?hl=jp&gl=JP&"
  @sq = URI.encode_www_form(q: ws["C3"])
  @index_host += @sq

  charset = nil

  html = open(@index_host, 'User-Agent' => user_agent) do |f|
    charset = f.charset
    f.read
  end

  @index_doc = Nokogiri::HTML.parse(html, nil, charset)

  link = @index_doc.css('//div[@class="r"]/a')

#検索窓のURLから上位４つのサイトのURLをとってきてeachで回して@search_site配列に入れる
  @search_site=[]
  yoko=6 #サイトURLを書く列を指定する
  link.each do |si|
    site_url=si.attributes["href"].value
    @search_site << site_url
    ws[9,yoko]=site_url
    yoko=yoko+2
  end

  yoko2=4
  hh_r=6
  hhh_r=7
#サイトごとにh2とh3を取ってきてシートに追加
  @search_site.each do |sq|
    @host=sq
    @url=URI.encode(@host)
    @doc = Nokogiri::HTML(open(@url))
    title=@doc.at_css("title").text
    h2=@doc.css("h2")
    h3=@doc.css("h3")
	  n=13 #h2の行を指定
	  m=13 #h3の行を指定
    h2.each do |hh|
	    h2=hh.text
      ws[n,hh_r]=h2
	    n=n+1
    end
    h3.each do |hhh|
	    h3=hhh.text
      ws[m,hhh_r]=h3
	    m=m+1
    end
    ws[8,yoko2]=title
    ws.save
	  yoko2=yoko2+2
	  hh_r=hh_r+2
	  hhh_r=hhh_r+2
  end
 end

one
 
