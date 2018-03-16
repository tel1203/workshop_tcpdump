#!/usr/bin/ruby

require 'webrick'

# 拡張子「.rb」ファイルをCGIとして実行可能にする。
module WEBrick
  module HTTPServlet
    FileHandler.add_handler("rb", CGIHandler)
  end 
end

# 動作設定
httpdOpt_docRoot = (ARGV[0] != nil ? ARGV[0] : '.')
httpdOpt_port = (ARGV[1] != nil ? ARGV[1] : 5000)

path = File.expand_path("access.log", Dir.pwd)
f = File.open(path, "a")
f.sync = true

opt = { 
	:DocumentRoot   => httpdOpt_docRoot,
	:Port           => httpdOpt_port,
	:BindAddress    => nil,
	:DirectoryIndex => ['index.html'],
	:AccessLog => [
		[f, WEBrick::AccessLog::COMBINED_LOG_FORMAT]
	],

#	:RequestCallback => lambda do |req, res|
#		WEBrick::HTTPAuth.basic_auth(req, res, "Authentication") do |username, password|
#			username == 'festival' && password == 'festival'
#		end
#	end
	
}
server = WEBrick::HTTPServer.new(opt)

# CGIを実行可能にする
server.mount("/", WEBrick::HTTPServlet::FileHandler, httpdOpt_docRoot)

# サーバの終了シグナルを設定する
['INT', 'TERM'].each {|signal| 
  trap(signal) {server.shutdown}
}

# サーバを開始する
server.start

