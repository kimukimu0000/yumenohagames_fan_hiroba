require "test_helper"

class GuestAccessTest < ActionDispatch::IntegrationTest
  setup do
    post guest_session_path
    @guest = User.find_by!(email_address: User::GUEST_EMAIL)
  end

  test "ゲストとしてログインできる" do
    assert @guest.guest?
    assert_redirected_to mypage_path

    follow_redirect!
    assert_response :success
  end

  test "ゲストはユーザー情報の編集画面を開けない" do
    get edit_mypage_path

    assert_redirected_to mypage_path
    assert_equal "ゲストユーザーは情報の変更・退会ができません。",
                 flash[:alert]
  end

  test "ゲストはユーザー情報を更新できない" do
    original_name = @guest.name
    original_email = @guest.email_address

    patch mypage_path, params: {
      user: {
        name: "変更テスト",
        email_address: "changed@example.com"
      }
    }

    assert_redirected_to mypage_path

    @guest.reload
    assert_equal original_name, @guest.name
    assert_equal original_email, @guest.email_address
  end

  test "ゲストは退会できない" do
    assert_no_difference "User.count" do
      delete mypage_path
    end

    assert_redirected_to mypage_path
    assert User.exists?(@guest.id)
  end
end
