require 'idea_box'
require 'Haml'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  # http://www.sinatrarb.com/configuration.html
  set :public_folder, -> { File.join(root, "public") }

  not_found do
    haml :error
  end

  get '/' do
     haml :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  post '/' do
    idea = IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    haml :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/link' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.add_link(params[:link])
    # haml :details, locals: {link: link}
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/:id/details' do |id|
    idea = IdeaStore.find(id.to_i)
    haml :details, locals: {idea: idea}
  end

  get '/:id/home' do
    redirect '/'
  end
end
