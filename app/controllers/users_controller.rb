class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  before_action :restrict_guest_account, only: %i[edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_session_path,
                  notice: "会員登録が完了しました。ログインしてください。",
                  status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

def show
  @user = Current.user
  @posts = @user.posts.order(created_at: :desc)
end

def edit
  @user = Current.user
end

def update
  @user = Current.user

  if @user.update(profile_params)
    redirect_to mypage_path,
                notice: "ユーザー情報を更新しました。",
                status: :see_other
  else
    render :edit, status: :unprocessable_entity
  end
end


def destroy
  @user = Current.user
  @user.destroy!

  terminate_session
  reset_session

  redirect_to signup_path,
              notice: "退会しました。ご利用ありがとうございました。",
              status: :see_other
end

  private

  def restrict_guest_account
  return unless Current.user.guest?

  redirect_to mypage_path,
              alert: "ゲストユーザーは情報の変更・退会ができません。",
              status: :see_other
end

def profile_params
  params.require(:user).permit(:name, :email_address)
end

  def user_params
    params.require(:user).permit(
      :name,
      :email_address,
      :password,
      :password_confirmation
    )
  end
end
