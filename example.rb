require 'sinatra'
require 'debugger'
require 'neography'

#DB_URL = ENV['DB_URL']
#DB_USERNAME = ENV['DB_USERNAME']
#DB_PASSWORD = ENV['DB_PASSWORD']

Tilt.register Tilt::ERBTemplate, 'html.erb'

set :neo, Neography::Rest.new

#def create_and_check_node(attributes={})
#  @neo = settings.neo
#  new_node = @neo.create_node(attributes)
#  response = @neo.get_node(new_node)
#  attributes.each do |k,v|
#    response['data'][k].should == v
#  end
#  new_node
#end


get '/hi' do
  @neo = settings.neo

  # number of nodes
  neo_response = @neo.execute_query('start n=node(*) return count(n)')
  @num_nodes = neo_response['data'].flatten[0]

  neo_response = @neo.execute_query('start n=node(*) match n-[r]->() return r')
  @num_relations = neo_response['data'].size

  erb :index
end
