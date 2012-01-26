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
   { 
   	 :data => request.url ,
     :cypher => request.url + "cypher" ,
	 :relationship_index => request.url + "db/data/index/relationship" ,
	 :node => request.url + "db/data/node" ,
	 :relationship_types => request.url + "db/data/relationship/types" ,
	 :batch => request.url + "db/data/batch" ,
	 :extensions_info => request.url + "db/data/ext" ,
	 :node_index => request.url + "db/data/index/node" ,
	 :reference_node => request.url + "db/data/index/node/0" ,
     :extensions => { :GremlinPlugin => { :execute_script => request.url + "raw-gremlin" }}
   }.to_json
end