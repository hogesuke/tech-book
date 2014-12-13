# coding: utf-8

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord' # todo こいつの使い方をちゃんと調べる
require 'net/http'
require 'xmlsimple'
require 'json'
require 'active_record'
require_relative './model/user'
require_relative './model/field'

ActiveRecord::Base.configurations = YAML.load_file('./db/database.yml')
ActiveRecord::Base.establish_connection('development')

get '/user/my/entry' do
  # todo OAuthを実装したらログインユーザで絞るように修正
  fields = User.find(1).fields

  entries = []
  fields.each{|field|
    url = URI.parse("http://b.hatena.ne.jp/search/tag?q=#{field.name}&mode=rss")
    req = Net::HTTP::Get.new(url.path + '?' + url.query)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    entries.concat(XmlSimple.xml_in(res.body)['item'])
  }

  headers({'Content-Type' => 'application/json'})
  entries.to_json
end

get '/user/me' do
  # todo ログインユーザ情報の取得
end

get '/field' do
  # todo ウォッチ対象分野の取得
  field = Field.all

  headers({'Content-Type' => 'application/json'})
  field.to_json
end

get '/user/my/field' do
  # todo ウォッチ対象分野の取得
end

post '/user/my/field' do
  # todo ウォッチ対象分野の追加
end

delete '/user/my/field' do
  # todo ウォッチ対象分野の削除
end

post '/user/my/checked' do
  # todo エントリー確認済み
end

delete '/user/my/checked' do
  # todo エントリー確認済みの解除
end

get '/user/my/later' do
  # todo エントリーあとで読むの取得
end

post '/user/my/later' do
  # todo エントリーあとで読むの追加
end

delete '/user/my/later' do
  # todo エントリーあとで読むの削除
end