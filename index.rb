require 'sinatra'
require 'fileutils'
set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
   haml :index
end

post '/download' do
   list = Dir.glob("./files/*.*").map{|f| f.split('/').last}
   if list.size >= 30
      FileUtils.rm_f Dir.glob("./files/*")
   end
   system("./youtube-dl/youtube-dl -x --audio-format mp3 -f 'best[filesize<80M]' #{params['link']} -o 'files/%(title)s.%(ext)s'")
   list = Dir.glob("./files/*.*").map{|f| f.split('/').last}
   sorted_list = list.sort_by {|filename| File.ctime("./files/#{filename}") }
   send_file "./files/#{sorted_list.last}", :filename => sorted_list.last, :type => 'Application/octet-stream'
   
   redirect '/'
  
end