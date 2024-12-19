# frozen_string_literal: true

# ApplicationHelperモジュールは、アプリケーション全体で使用されるヘルパーメソッドを提供します。
module ApplicationHelper
  def back_link(partner)
    if controller_name == 'partners' && action_name == 'edit'
      link_to(partner_path(partner), class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif %w[foods walks medications].include?(controller_name) && action_name == 'edit'
      link_to(partner_path(partner), class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'partners' && action_name == 'show'
      link_to(root_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'partners' && action_name == 'new'
      link_to(root_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'users' && action_name == 'new'
      link_to(login_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'settings' && %w[name_change privacy_policy terms_of_use news].include?(action_name)
      link_to(settings_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'password_resets' && action_name == 'new'
      link_to(settings_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'email_changes' && action_name == 'new'
      link_to(settings_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    elsif controller_name == 'contacts' && action_name == 'new'
      link_to(settings_path, class: 'navbar-brand') do
        content_tag(:i, '', class: 'fas fa-chevron-left')
      end
    end
  end
end
