# frozen_string_literal: true

module SharedPartnerSetup
  def create_shared_partners(user1, partners1, user2, partners2)
    # user1 -> user2 の共有を作成
    partners1.each do |partner|
      PartnerShare.create!(
        partner_id: partner.id,
        user_id: user1.id, # user1が共有した側
        shared_by: user2.id # user2が共有を受けた側
      )
    end

    # user2 -> user1 の共有を作成
    partners2.each do |partner|
      PartnerShare.create!(
        partner_id: partner.id,
        user_id: user2.id, # user2が共有した側
        shared_by: user1.id # user1が共有を受けた側
      )
    end
  end

  def create_token(user, partner = nil, expiration_date: 1.day.from_now)
    Token.create!(
      token: SecureRandom.hex(10),
      user_id: user.id,
      partner_id: partner&.id,
      expiration_date: expiration_date
    )
  end

  def create_shared(partner, user, share_user)
    PartnerShare.create!(
      partner_id: partner.id,
      user_id: user.id, # 共有した側
      shared_by: share_user.id # 共有を受けた側
    )
  end
end
