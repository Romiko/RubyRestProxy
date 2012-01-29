require 'sinatra'
require 'rest-client'
require 'json'

# Documentation on rest client http://rubydoc.info/gems/rest-client/1.6.7/frames
rest = RestClient::Resource.new(ENV['NEO4J_URL'])

before do
    content_type 'application/json'
  end

post '/db/data/ext/GremlinPlugin/graphdb/execute_script' do
    data = request.body.read;
    begin
      data = JSON.parse(data)
    rescue
    end 
    data = {:query => data } unless data.kind_of?(Hash)
    rest["/db/data/ext/GremlinPlugin/graphdb/execute_script"].post data.to_json, 
                 {:accept=>"application/json",:content_type=>"application/json"}
end

# Neo4j REST Routes 
get '/' do  
	response = RestClient.get ENV['NEO4J_URL'] + '/db/data/', {:content_type => :json, :accept => :json}
	ReplaceHostNameWithProxyHostName(response)
end

get '/db/data/node/:nodeid' do
	response = RestClient.get ENV['NEO4J_URL'] + '/db/data/node/' +  params[:nodeid], {:content_type => :json, :accept => :json}
	ReplaceHostNameWithProxyHostName(response)
end

get '/db/data/node/:nodeid/properties' do
	response = RestClient.get ENV['NEO4J_URL'] + '/db/data/node/' +  params[:nodeid] + '/properties', {:content_type => :json, :accept => :json}
	ReplaceHostNameWithProxyHostName(response)
end

put '/db/data/node/:nodeid/properties' do
	begin
	data = request.body.read;
    data = JSON.parse(data)
    data = {:query => data } unless data.kind_of?(Hash)
	address = "/db/data/node/" +  params[:nodeid] + "/properties"
    response = rest[address].put data.to_json, 
                 {:accept=>"application/json",:content_type=>"application/json"}
				 
	if response == ""
	status 204
	end
	
	rescue Exception => e 
		response = 'HOSTRESOURCE: ' + address + ' MESSAGE: ' + e.message + ' BACKTRACE: ' + e.backtrace.inspect
		if response.include? "404"
		status 404
		end
		if response.include? "409"
		status 409
		end
	end	
end

post '/db/data/node/:nodeid/relationships' do
    data = request.body.read;
    begin
      data = JSON.parse(data)
    rescue
	end
	data = data unless data.kind_of?(Hash)
	rest["/db/data/node/" + params[:nodeid] + "/relationships"].post data.to_json, 
				 {:accept=>"application/json",:content_type=>"application/json"}
end

get '/db/data/node/:nodeid/relationships/:relationships' do
	response = RestClient.get ENV['NEO4J_URL'] + '/db/data/node/' +  params[:nodeid] + '/relationships/' + params[:relationships], {:content_type => :json, :accept => :json}
	ReplaceHostNameWithProxyHostName(response)
end

post '/db/data/batch' do
    data = request.body.read;
    begin
      data = JSON.parse(data)
    rescue
    end 
    data = data unless data.kind_of?(Hash)
    rest["/db/data/batch"].post data.to_json, 
                 {:accept=>"application/json",:content_type=>"application/json"}
end

delete '/db/data/relationship/:relationshipid' do
	begin
	address = ENV['NEO4J_URL'] + '/db/data/relationship/' +  params[:relationshipid]
	response = RestClient.delete address

	if response == ""
	status 204
	end

	rescue Exception => e 
		response = 'HOSTRESOURCE: ' + address + ' MESSAGE: ' + e.message + ' BACKTRACE: ' + e.backtrace.inspect
		if response.include? "404"
		status 404
		end
		if response.include? "409"
		status 409
		end
	end
end

delete '/db/data/node/:nodeid' do
	begin
	address = ENV['NEO4J_URL'] + '/db/data/node/' +  params[:nodeid]
	response = RestClient.delete address
	
	if response == ""
	status 204
	end
	
	rescue Exception => e 
		response = 'HOSTRESOURCE: ' + address + ' MESSAGE: ' + e.message + ' BACKTRACE: ' + e.backtrace.inspect
		if response.include? "404"
		status 404
		end
		if response.include? "409"
		status 409
		end
	end
end

# functions

def ReplaceHostNameWithProxyHostName(response)
   response.gsub(/(http:\/\/\w+\W*.*\/db\/data)/, "http://" + ENV['APP_NAME']  + ".heroku.com/db/data")
end