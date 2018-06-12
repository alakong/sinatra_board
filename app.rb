gem 'json', '~> 1.6'
require 'sinatra'
require "sinatra/reloader"
require 'bcrypt'
require_relative 'model.rb'

#before do
#    p '********************'
#    p params
#    p '********************'
#end


get '/'do
    send_file 'views/index.html'
end

get '/lunch' do
    
    @menu=["새우","게","연어","초밥","피자","냉면"].sample

erb :lunch
end

#게시글을 모두 보여주는 곳
get '/posts' do
@posts=Post.all
#@postsorder=Post.all(order=>[:id.desc])#정렬순서 바꾸기
   
    erb :'posts/posts'
end

#게시글을 쓸 수 있는 곳
get '/posts/new' do
    erb :'posts/new'
end

get '/posts/create' do
   
   @title = params[:title]
   @body = params[:body]
    Post.create(title: @title, body: @body)
   
    erb :'posts/create'
end

#CRUD-Read
#variable routing을 통해서 특정한 게시물을 가져온다.
get '/posts/:id' do
    @id = params[:id]
    @post = Post.get(@id)
    
    erb :'posts/show'
    end

#CRUD-Delete
#삭제하기 버튼에서 연결
get '/posts/destroy/:id' do
    @id= params[:id]
    Post.get(@id).destroy
    erb :'posts/destroy'

end

#CRUD-Update_1 수정화면 불러오기
get '/posts/edit/:id' do

    @id=params[:id]
    @post=Post.get(@id)
    erb :'posts/edit'

end
#CRUD-Update_2
get '/posts/update/:id' do

    @id = params[:id]
    Post.get(@id)
    Post.get(@id).update(title: params[:title],body:params[:body])
  #수정 후 다시 show page로!
   redirect '/posts/'+@id
   
   #@post=Post.get(@id)
    #erb :'posts/update'
end



#####UserList

get '/user' do
@user=User.all
erb :'/user/list'
end


get '/user/new' do
erb :'/user/new'
end


get '/user/add' do
 #password는 암호화해서 저장함
  User.create(name: params[:name], 
  password: BCrypt::password.create(params[:pwd]), email: params[:email])
  redirect '/user' 
end

get '/user/:id' do
@id=params[:id]
@user=User.get(@id)

erb :'/user/show'
end

get '/user/destroy/:id' do
    User.get(params[:id]).destroy
    redirect '/user' 
end


get '/user/edit/:id' do
    @id=params[:id]
    @user=User.get(@id)

erb :'user/edit'    
end


get '/user/update/:id' do
    
    User.get(params[:id]).update(name: params[:name],password: params[:pwd], email: params[:email])
    @user=User.get(params[:id])
   erb :'/user/show'

end



    