class ShareService
    def initialize(user, partner = nil, host_url)
      @user = user
      @partner = partner
      @host_url = host_url
    end
  
    def create_share
      token = generate_token
      return nil unless token
  
      share_url = "#{@host_url}share/#{token.token}"
      {
        share_url: share_url,
        share_text: generate_share_text(share_url),
        qr_code_svg: generate_qr_code(share_url)
      }
    end
  
    private
  
    def generate_token
      if @partner
        Token.create_share_for(user: @user, partner: @partner)
      else
        Token.create_share_for(user: @user)
      end
    end
  
    def generate_share_text(url)
      ApplicationController.render(
        partial: "shared/share_text_template",
        locals: { share_url: url, user_name: @user.name }
      )
    end
  
    def generate_qr_code(url)
      qr_code = RQRCode::QRCode.new(url)
      qr_code.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 5,
        standalone: true
      )
    end
end