require 'nokogiri'
require 'open-uri'
require 'pry-rails'
require 'pry-byebug'
require 'google_drive'
require 'pp'


 def one
   # config.jsonを読み込んでセッションを確立
  session = GoogleDrive::Session.from_config("config.json")
# スプレッドシートをURLで取得
  sp=session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1WoF_bsosC2wVEZ0BGB_oYmi5ZbrUXy_w4uS2rI0l178/edit#gid=0")
# "シート1"という名前のワークシートを取得
  ws = sp.worksheet_by_title("20")
  @search_query=[]
  @search_query << ws["D9"]
  @search_query << ws["F9"]
  @search_query << ws["H9"]
  @search_query << ws["J9"]
  t=4
  hh_r=4
  hhh_r=5
  @search_query.each do |sq|
    @host=(sq)
    @url=URI.encode(@host)
    @doc = Nokogiri::HTML(open(@url))
    title=@doc.at_css("title").text
    h2=@doc.css("h2")
    h3=@doc.css("h3")
	n=13
	m=13
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
    ws[8,t]=title
    ws.save
	t=t+2
	hh_r=hh_r+2
	hhh_r=hhh_r+2
  end
 end

one
 
