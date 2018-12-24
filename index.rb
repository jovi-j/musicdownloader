require 'sinatra'
set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
   haml :index
end

post '/download' do
   system("./youtube-dl/youtube-dl -x --audio-format mp3 -f 'best[filesize<80M]' #{params['link']} -o 'files/%(title)s.%(ext)s'")
   list = Dir.glob("./files/*.*").map{|f| f.split('/').last}
   send_file "./files/#{list[-1]}", :filename => list[-1], :type => 'Application/octet-stream'
   "Hello"
end