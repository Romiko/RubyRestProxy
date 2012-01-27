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
	response.gsub(/(http:\/\/\w+\W*.*\/db\/data)/, "http://" + ENV['APP_NAME']  + ".heroku.com/db/data")
end

get 'db/data/*' do
values = params[:splat]
response = RestClient.get ENV['NEO4J_URL'] + '/db/data/' + values[0] , {:content_type => :json, :accept => :json}
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