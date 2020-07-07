class ShareService

  def initialize

  end

  def run  user, referral_ids
    @user = user
    @referral_ids = referral_ids
  end

  def record_visit request, refid, params
    attrs = {
      referral_code: refid,
      referrer_url: request.referrer,
      ipaddress: request.remote_ip
    }
    if params[:utm_name]
  end
end
