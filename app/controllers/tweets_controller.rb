class TweetsController < ApplicationController
    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if logged_in?
            if params[:content] == ""
                redirect '/tweets/new'
            else
                @tweet = Tweet.new(params)
                if @tweet.save
                    current_user.tweets << @tweet
                    redirect "/tweets/#{@tweet.id}"
                end
            end
        else
            redirect to "/tweets/new"
        end
    end

    get '/yourtweets' do
        if logged_in?
            @user = User.find_by_slug(params[:slug])
            erb :'tweets/user_tweets'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'tweets/tweet'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if params[:content] == ""
                redirect "/tweets/#{params[:id]}/edit"
            else
                if @tweet.user_id == @current_user.id
                    erb :'tweets/edit'
                end
            end
        else
          redirect '/login'
        end
    end

    patch '/tweets/:id' do
        if logged_in?
            if params[:content] == ""
                redirect "/tweets/#{params[:id]}/edit"
            else
                @tweet = Tweet.find_by_id(params[:id])
                if @tweet.user_id == @current_user.id
                    @tweet = Tweet.update(content: params[:content])
                    redirect "/tweets/#{params[:id]}"
                end
            end
        else
          redirect '/login'
        end
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user_id == @current_user.id
                @tweet.delete
                redirect "/tweets"
            end
        else
          redirect '/login'
        end
    end

end
