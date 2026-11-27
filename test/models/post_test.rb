require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @strategy_post = posts(:one)
    @strategy_post.update!(
      title: "ボス攻略100%の記録",
      body: "special_itemを使いました"
    )

    @review_post = posts(:two)
    @review_post.update!(
      title: "遊んだ感想",
      body: "街の音楽が好きです"
    )
  end

  test "タイトルの一部で検索できる" do
    assert_equal [ @strategy_post.id ],
                 Post.search("攻略").pluck(:id)
  end

  test "本文の一部で検索できる" do
    assert_equal [ @review_post.id ],
                 Post.search("音楽").pluck(:id)
  end

  test "キーワードが空欄ならすべての投稿を返す" do
    assert_equal Post.order(:id).pluck(:id),
                 Post.search("").order(:id).pluck(:id)
  end

  test "一致する投稿がなければ空の結果を返す" do
    assert_empty Post.search("存在しないキーワード")
  end

  test "パーセントを普通の文字として検索できる" do
    assert_equal [ @strategy_post.id ],
                 Post.search("%").pluck(:id)
  end

  test "アンダースコアを普通の文字として検索できる" do
    assert_equal [ @strategy_post.id ],
                 Post.search("_").pluck(:id)
  end
end
