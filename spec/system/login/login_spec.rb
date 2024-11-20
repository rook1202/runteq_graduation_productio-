require 'rails_helper'

RSpec.describe 'ログイン・ログアウト機能', type: :system do
  let(:user) { create(:user) }

  it '正常なログインが成功する' do
    visit root_path
    expect(current_path).to eq(login_path), '未ログイン時にroot_pathからlogin_pathにリダイレクトされていません'

    p user # ユーザーオブジェクトを出力
    puts User.all.inspect # データベース内のユーザーを確認

    fill_in 'email', with: user.email
    fill_in 'password', with: '12345678'
    # 入力内容をデバッグ出力
    p find('input[name="email"]').value
    p find('input[name="password"]').value
    click_button 'ログイン'

    expect(page).to have_content('ログインしました'), 'フラッシュメッセージ「ログインしました」が表示されていません'
    expect(current_path).to eq(root_path) # ペット一覧画面に遷移
  end

  it '誤った情報でログインするとエラーになる' do
    visit root_path
    fill_in 'email', with: 'wrong@example.com'
    fill_in 'password', with: 'wrongpassword'
    click_button 'ログイン'

    expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
    expect(current_path).to eq(login_path), 'ログイン失敗時にログイン画面に戻ってきていません'
  end

  describe 'ログアウト' do
    before do
      login_as(user)
    end
    it 'ログアウトできること' do
        # ログアウトリンクをクリック
        find('a.nav-link', text: 'ログアウト').click
    
        expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
        expect(current_path).to eq login_path
    end
    
    it 'モバイル画面でもログアウトリンクが機能する' do
        page.driver.browser.manage.window.resize_to(375, 667) # モバイルサイズ
      
        # アイコンまたはリンクをクリック
        find('a.nav-link i.fa-door-open').click
      
        expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
        expect(current_path).to eq login_path
    end
  end

end