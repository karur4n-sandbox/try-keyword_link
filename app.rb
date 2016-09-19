require 'csv'
require 'rack/utils'

keywords = {}

CSV.read('keywords.csv', headers: true).each do |row|
  name = row['name']

  keywords.merge!("#{Rack::Utils.escape(name)}": {
    id: row['id'].to_i,
    name: name,
    name_length: row['name_length'].to_i
  })
end

txt = 'ファイターは2ターン目に使いましょう。'

pattern = ''

keyword_ary = keywords.keys.map do |k|
  keywords[k]
end
# ソートする必要ないと思う
# end.sort {|k1, k2| k2[:name_length] <=> k1[:name_length]}.each do |k|
#   pattern += k[:name] + '|'
# end

keyword_ary.each do |k|
  pattern += k[:name] + '|'
end

# 最後のパイプを削除する
pattern.slice!(-1)

txt.gsub!(/(#{pattern})/) do |m|
  k = keywords[Rack::Utils.escape($1).to_sym]
  "<a href='/cards/#{k[:id]}'>#{k[:name]}</a>"
end

p txt
