require 'openssl'
require 'base64'

class DataDecryption

  ## Initialize Private Key Path
  def initialize
  	@private_key_str = "#{Rails.root}/config/decryption/rahul"
  end

  ## Generate Private Key Object
  def private_key
    OpenSSL::PKey::RSA.new(File.read(@private_key_str),"codecravers123")
  end

  ## Decrypt Details
  def decrypted_data(encrypted_string)
    private_key.private_decrypt(Base64.decode64(encrypted_string))
  end
end
