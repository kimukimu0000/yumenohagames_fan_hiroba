class GuestSessionsController < ApplicationController
  allow_unauthenticated_access only: :create

  def create
    if authenticated?
      redirect_to mypage_path, status: :see_other
      return
    end

    user = User.guest_account

    reset_session
    start_new_session_for(user)

    redirect_to mypage_path,
                notice: "ゲストとしてログインしました。",
                status: :see_other
  end
end
