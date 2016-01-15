require 'spec_helper'
require 's3cabinet'


describe S3Cabinet do

	before(:all) do
		FileUtils.mkdir_p "test_s3_dir"

		r, w = IO.pipe
		@fakes3_server_process_pid = Process.spawn("fakes3 -r test_s3_dir -p 9660", :out => w, :err => [:child, :out])

		@s3 = S3Cabinet::S3Cabinet.new("FAKE_ACCESS_ID", "FAKE_ACCESS_SECRET", "test", "http://localhost:9660")
		loop do 
			# some code here
			begin
				@s3.set "x", 1000
				break
			rescue => e

				puts e

				sleep 1
			end
		end 
	end

	after(:all) do
		Process.kill 15, @fakes3_server_process_pid
		FileUtils.rm_r "test_s3_dir"
	end

	it 'has a version number' do
		expect(S3Cabinet::VERSION).not_to be nil
	end

	it 'can set' do
		@s3.set "x", 100
	end

	it 'can get what it sets' do
		@s3.set "x", 99
		expect(@s3.get "x").to be 99
	end

	it 'can set object' do
		@s3.set "some_object", {name: "Jim"}
		expect(@s3.get("some_object").is_a? Hash).to be true
		expect(@s3.get("some_object")["name"]).to eq "Jim"
	end

	it 'can get url' do
		curled_str = `curl #{@s3.url "x"} 2>/dev/null`
		raw_str = @s3.get_raw "x"

		expect(curled_str).to eq raw_str
	end
end
