require "s3cabinet/version"

require "aws-sdk-core"
require "json"

module S3Cabinet

  class S3Cabinet
  	def initialize(access_id, access_key, bucket, region)
  		@access_id = access_id
  		@access_key = access_key
  		@bucket = bucket
  		@region = region

		@region_to_bucket_endpoint = {
			"us-east-1" => "https://s3.amazonaws.com",
			"us-west-1" => "https://s3-us-west-1.amazonaws.com",
			"us-west-2" => "https://s3-us-west-2.amazonaws.com",
			"eu-west-1" => "https://s3-eu-west-1.amazonaws.com",
			"eu-central-1" => "https://s3.eu-central-1.amazonaws.com",
			"ap-south-1" => "https://s3.ap-south-1.amazonaws.com",
			"ap-northeast-1" => "https://s3-ap-northeast-1.amazonaws.com",
			"ap-northeast-2" => "https://s3-ap-northeast-2.amazonaws.com",
			"ap-southeast-1" => "https://s3-ap-southeast-1.amazonaws.com",
			"ap-southeast-2" => "https://s3-ap-southeast-2.amazonaws.com",
			"sa-east-1" => "https://s3-sa-east-1.amazonaws.com",
			"cn-north-1" => "https://s3.cn-north-1.amazonaws.com.cn"
		}

  		if access_id.is_a? Hash
  			hash = @access_id
  			@access_id = hash[:access_id]
  			@access_key = hash[:access_key]
  			@bucket = hash[:bucket]
  			@region = hash[:region]
  		end
  	end

  def endpoint_url
  	@endpoint_url ||= begin
  		theurl = @region_to_bucket_endpoint[@region]

  		if theurl.nil?
  			theurl = "https://s3.#{@region}.amazonaws.com"
  		end

  		theurl
  	end
  end

	def s3
		if @s3 == nil
			endpoint = endpoint_url
			if endpoint
				@s3 = Aws::S3::Client.new(access_key_id: @access_id, secret_access_key: @access_key, region: @region)
			else
				@s3 = Aws::S3::Client.new(access_key_id: @access_id, secret_access_key: @access_key, region: "us-east-1", endpoint: @region, force_path_style: true)
			end
		end
		@s3
	end

	def url(key)
		the_url = endpoint_url

		if the_url
			"#{the_url}/#{@bucket}/#{key}"
		else
			"#{@region}/#{@bucket}/#{key}"
		end
	end

	def set(key, value)
		val_str = { value: value, date: Time.now.to_i }.to_json
		set_raw(key, val_str)
	end

	def get(key)
		begin
			JSON.parse(get_raw(key))["value"]
		rescue
		end
	end

	def set_raw(key, value_string)
		s3.put_object(bucket: @bucket, key: key, body: value_string )
	end

	def get_raw(key)
		resp = s3.get_object(bucket: @bucket, key: key)
		resp.body.read
	end

	def del(key)
		resp = s3.delete_object(bucket: @bucket, key: key)
	end

	def list(prefix)
		resp = s3.list_objects(bucket: @bucket, prefix: prefix)
		resp.contents.map { |x| x.key }
	end

  end
end
