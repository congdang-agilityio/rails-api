class ApplicationController < ActionController::API

  def letsencrypt
    # second-part-of-string-random-characters
    # will be a key that certbot / letsencrypt create for you
    # you need to replace "second-part-of-string-random-characters" later
    render text: "#{params[:id]}.UvCiXw1vKACT1CoPDClUE8nFQSr9wLFTRpcH8rENf-o"
  end

end
