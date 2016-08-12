class Api::V1::SwipeController < ApplicationController

  respond_to :json

def show
find_prospects
end

def create
  swiped_user = User.find(params[:swiped_user_id])
  swipe = Swipe.new(user_id: @current_user.id,swiped_user: swiped_user,yes_swipe: params[:yes_swipe])
  if swipe.save
    if Swipe.where(user_id: swiped_user.id).pluck(:yes_swipe)
      render json: swipe, status: 201
    else
      head 200
    end
  else
    render json: {errors: swipe.errors}, status: 422
  end
end



private

def find_prospects
  # swiped_ids = Swipe.where(user_id: @current_user.id).pluck(:swiped_user_id)
  users_not_swiped =  User.where.not(id: @current_user.swipes_as_user.select(:swiped_user_id)).ids
  users_to_show = User.where(id: users_not_swiped,sex: @current_user.looking_for)
  render json: users_to_show, status: 201
end

def previously_swiped
  swiped_ids = Swipe.where(user_id: @current_user.id).swiped_user_id
end

def swipe_params
  params.permit(:swiped_user_id,:yes_swipe)
end

end
