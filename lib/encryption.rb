class Encryption

  def self.crypt(info, key)
    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.iv = 'ct3m3xec7tp6qrf9'
    cipher.encrypt
    cipher.key = key
    cipher_text = cipher.update(info)
    cipher_text << cipher.final
    cipher_text.unpack("H*")[0]
  end

  def self.decrypt(info, key)
    begin
      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      cipher.iv = 'ct3m3xec7tp6qrf9'
      cipher.decrypt
      cipher.key = key
      out = cipher.update([info].pack("H*"))
      out << cipher.final
    rescue
      nil
    end
  end

end
