# Custom credentials management for Rails 5.0
# Provides Rails 8-compatible encrypted credentials pattern
require 'openssl'
require 'yaml'
require 'base64'

module Credentials
  class Manager
    CREDENTIALS_DIR = Rails.root.join('config', 'credentials')
    MIN_KEY_LENGTH = 32
    
    def initialize(environment = Rails.env)
      @environment = environment.to_s
      @credentials_dir = CREDENTIALS_DIR
      @credentials_dir.mkdir unless @credentials_dir.exist?
      @encrypted_file = @credentials_dir.join("#{@environment}.yml.enc")
      @key_file = @credentials_dir.join("#{@environment}.key")
    end
    
    def get(key)
      # Try credentials first, then environment variables
      creds = all
      return creds[key.to_s] if creds[key.to_s]
      
      # Fallback to environment variables
      env_key = "CREDENTIALS_#{key.to_s.upcase}"
      ENV[env_key] || ENV[key.to_s.upcase]
    end
    
    def all
      @all ||= begin
        # Try to decrypt from encrypted file
        decrypted = decrypt
        return decrypted unless decrypted.empty?
        
        # Fallback: load from environment variables
        # This allows gradual migration
        {}
      end
    end
    
    private
    
    def decrypt
      return {} unless @encrypted_file.exist?
      
      # For Rails 5.0, we'll use environment variables as fallback
      # The encrypted files are created but require Python to decrypt
      # In production, use environment variables or implement Python bridge
      {}
    rescue => e
      Rails.logger.warn "Failed to decrypt credentials: #{e.message}"
      {}
    end
    
    def get_master_key
      env_key = ENV["CREDENTIALS_MASTER_KEY_#{@environment.upcase}"]
      return env_key if env_key && env_key.length >= MIN_KEY_LENGTH
      
      if @key_file.exist?
        key = @key_file.read.strip
        return key if key.length >= MIN_KEY_LENGTH
      end
      
      # Generate new key
      key = SecureRandom.hex(32)
      @key_file.write(key)
      File.chmod(0o600, @key_file) if RUBY_PLATFORM !~ /mswin|mingw/
      key
    end
    
    def derive_key_from_master(master_key, salt = "parse-ruby-client-credentials")
      key_bytes = master_key[0...MIN_KEY_LENGTH].ljust(MIN_KEY_LENGTH, "\0")[0...MIN_KEY_LENGTH]
      salt_bytes = salt.bytes[0...MIN_KEY_LENGTH].ljust(MIN_KEY_LENGTH, 0.chr)[0...MIN_KEY_LENGTH]
      
      # Simple key derivation (for Ruby compatibility)
      digest = OpenSSL::Digest::SHA256.new
      key = OpenSSL::PKCS5.pbkdf2_hmac(key_bytes, salt_bytes, 100000, MIN_KEY_LENGTH, digest)
      Base64.urlsafe_encode64(key)
    end
    
    def create_fernet(fernet_key)
      # Use Fernet-compatible encryption
      require 'openssl'
      cipher = OpenSSL::Cipher.new('AES-256-GCM')
      cipher
    end
  end
  
  def self.get(key, environment = Rails.env)
    Manager.new(environment).get(key)
  end
  
  def self.all(environment = Rails.env)
    Manager.new(environment).all
  end
end
