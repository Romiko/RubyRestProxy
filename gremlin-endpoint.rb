require 'sinatra'
require 'rest-client'
require 'json'

rest = RestClient::Resource.new(ENV['NEO4J_URL'])

post '/raw-gremlin' do
    data = request.body.read;
    begin
      data = JSON.parse(data)
    rescue
    end 
    data = {:query => data } unless data.kind_of?(Hash)
    rest["/db/data/ext/GremlinPlugin/graphdb/execute_script"].post data.to_json, 
                 {:accept=>"application/json",:content_type=>"application/json"}
end

# support some minimalistic exploration for the neo4j-jdbc driver
 
get '/' do
	rest["/db/data"].get
end