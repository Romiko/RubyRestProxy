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

# support some minimalistic exploration for the neo4j-jdbc driver and neo4jClient RootApiResponse
 
get '/' do  
	response = RestClient.get ENV['NEO4J_URL'] + '/db/data/', {:content_type => :json, :accept => :json}
	response.gsub("/(http:\/\/\w+\W*.*\/db\/data)/", "http://neo4jorbust.heroku.com/db/data")
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