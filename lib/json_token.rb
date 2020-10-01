class JsonToken

  ENCODE_KEY = 'a81ff92440ef53f902d3efd5449b369e69f09be95425088a4c7e7e52a27a75b0'.freeze
  PUBLIC_KEY = 'f4e7d7df328851eff178a3b4286ba92e'.freeze

  def self.encode(data)
    data = data.dup
    JWT.encode(data, ENCODE_KEY)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, ENCODE_KEY)[0])
  end
end
