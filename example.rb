require 'sinatra'
require 'sass'
require 'debugger'
require 'haml'
require 'neography'

get '/screen.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :screen
end

#DB_URL = ENV['DB_URL']
#DB_USERNAME = ENV['DB_USERNAME']
#DB_PASSWORD = ENV['DB_PASSWORD']

set :neo, Neography::Rest.new
set :movies_results, nil
set :people_results, nil

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

  @movies_results = settings.movies_results if settings.movies_results
  @people_results = settings.people_results if settings.people_results

  haml :index
end

post '/' do
  unless params[:search].empty?
    neo = settings.neo
    begin
      neo_response = neo.find_node_index('search', %[title:"#{params[:search]}"])
      settings.movies_results = neo_response ? neo_response.map{|x| x['data']} : nil

      neo_response = neo.find_node_index('people', %[name:"#{params[:search]}"])
      settings.people_results = neo_response ? neo_response.map{|x| x['data']} : nil
    rescue
      redirect '/'
    end
  end
  redirect '/'
end
