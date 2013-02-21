require 'sinatra'
require 'debugger'
require 'haml'
require 'neography'
require 'sass'

get '/screen.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :screen
end

#DB_URL = ENV['DB_URL']
#DB_USERNAME = ENV['DB_USERNAME']
#DB_PASSWORD = ENV['DB_PASSWORD']

set :neo, Neography::Rest.new
set :results, nil

#def create_and_check_node(attributes={})
#  @neo = settings.neo
#  new_node = @neo.create_node(attributes)
#  response = @neo.get_node(new_node)
#  attributes.each do |k,v|
#    response['data'][k].should == v
#  end
#  new_node
#end


get '/' do
  neo = settings.neo

  # number of nodes
  #neo_response = neo.execute_query('start n=node(*) return count(n)')
  #@num_nodes = neo_response['data'].flatten[0]

  # number of relations
  #neo_response = neo.execute_query('start n=node(*) match n-[r]->() return r')
  #@num_relations = neo_response['data'].size

  @results = settings.results if settings.results

  haml :index
end

post '/' do
  if params[:search]
    neo = settings.neo
    neo_response = neo.find_node_index('search', "title:#{params[:search]}")
    settings.results = neo_response ? neo_response.map{|x| x['data']} : nil
  end
  redirect '/'
end
