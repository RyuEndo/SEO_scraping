require 'nokogiri'
require 'open-uri'
require 'pry-rails'
require 'pry-byebug'
require 'google_drive'


 def index
   # config.jsonを読み込んでセッションを確立
  session = GoogleDrive::Session.from_config("config.json")
# スプレッドシートをURLで取得
  sp=session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1WoF_bsosC2wVEZ0BGB_oYmi5ZbrUXy_w4uS2rI0l178/edit#gid=0")
# "シート1"という名前のワークシートを取得
  ws = sp.worksheet_by_title("シート1")
   @main="https://www.google.com/search?q="
   @search_query=ws["B3"]
   @host=(@main+@search_query)
   @url=URI.encode(@host)
   @doc = Nokogiri::HTML(open(@url))
   @title=@doc.at_css(".r")
	 	 binding.pry
   url.each do |host|
     get_clinic(host)
   end
 end

index
  
#url配列のひとつづつに対して一覧から病院ごとのページのリンクを取得して、links配列に突っ込む
#links配列にeachをかけて欲しい情報を取ってくるためのget_infoメソッドに投げる
 def get_clinic(host)
      @url=host
      @doc = Nokogiri::HTML(open(@url))
      link= @doc.css(".title-box").css("a")
      
      link.each do |li|
        lin=li.attributes["href"].value
        get_info(lin)
      end
      
 end
 
#病院詳細のページから欲しい情報を持ってくる
 def get_info(link)
     information={}
     @url='https://nicoly.jp'+ link
     @doc = Nokogiri::HTML(open(@url))
     name= @doc.css("tr").css("td").text.split("／")[0].split("\n")[0]
     rate= @doc.at_css(".rating").text
     area=@doc.css("tr").css("td").text.split("／")[0].split("\n")[2].split(" ")[0]
     boss=@doc.at_css(".name").text
     information[:name]=name
     information[:rate]=rate
     information[:area]=area
     information[:boss]=boss
     puts information
     #診療科目も取りたい
 end

 links
 
 
