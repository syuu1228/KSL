#encoding:utf-8
=begin
	Copyright (C) alphaKAI 2013-2014 http://alpha-kai-net.info
	UNIX Shell Environment KSL in Ruby

  The MIT LICENSE http://opensource.org/licenses/MIT
=end

$KSL_INSTALLED_PATH = "."
require "find"
require "readline"
require_relative "#{$KSL_INSTALLED_PATH}/src/parser.rb"
require_relative "#{$KSL_INSTALLED_PATH}/src/kernel.rb"

VER = "0.0.3 rb for OSv"
$install_path = "#{Dir.pwd}/bin"
$pc_user_color = 36
class MainFunctions
	def initialize
		@parser = CommandParser.new
		@kernel = KaiKernel.new
		@shellstack = Array.new
	end
	def about
		puts "KSL in Ruby VERSION:#{VER}"
		puts "Copyright (C) alphaKAI 2013-2014 http://alpha-kai-net.info"
    puts "The MIT LICENSE http://opensource.org/licenses/MIT"
		puts "実装されているコマンドの一覧はhelpコマンドで確認できます"

    @baseOS = "OSv"
		puts "\n現在KSLが動作しているOS:#{@baseOS}\n\n"
	end
	def ShellLine(loop_count,error)
		path   = Dir.pwd
    pcname = "OSv"
                path = "/"
		unless error == 0
			print "#{error} "
		end
		
		commands = @parser.cmdlist
		tmp_ary = Array.new

		commands.each{|a|
			tmp_ary <<  a.split(".")[0]
		}
		commands = tmp_ary
		commands += Dir.entries(Dir.pwd)

		Readline.completion_proc = proc{|word|
			commands.grep(/\A#{Regexp.quote word}/)
		}
		input = Readline.readline("\r\e[#{$pc_user_color}m@#{pcname} \e[31m[KSL]\e[0m \e[1m#{path}\e[0m #{@kernel.prompt}",true)

		@shellstack << input
		@parser.parser(input)
		puts ""
	end
end

i=0
error=0
@mf = MainFunctions.new
@mf.about
loop do
	error=@mf.ShellLine(i,error)
	i+=1
end
