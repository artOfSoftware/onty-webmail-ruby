class AccountSecret < ActiveRecord::Base

  validates_presence_of :account_id
  validates_presence_of :account_name

  validates_numericality_of :account_id, :only_integer=>true

  validates_length_of :account_name, :within => 3..40
  validates_length_of :password, :within => 3..40

  validates_confirmation_of :password

  validates_uniqueness_of :account_name
  validates_uniqueness_of :account_id

  
  attr_accessor :password, :password_confirmation
  attr_accessor :password_old
  
  #  attr_protected :password_salt


  def self.get_by_user_id( userId )
    AccountSecret.where( "account_id=#{userId}" ).first()
  end


  def self.authenticate( username, userpass )
    a = where( :account_name=>username ).first()
    return nil if a.nil?
    return a if AccountSecret.hash_password(userpass, a.password_salt)==a.password_hash
    nil
  end


  def password=(pass)
    raise "Password must not be nil" if pass.nil?
    @password = pass

    self.password_salt = AccountSecret.make_random_string(10) if !self.password_salt?
    self.password_hash = AccountSecret.hash_password(@password, self.password_salt)
  end


  def clear_password!
    self.password_salt=""
    self.password_hash=""
    @password=""  #do i need this?
  end

  
  

protected

  def self.hash_password( pass, password_salt )
    raise "Password cannot be nil" if !pass
    raise "Password Salt cannot be nil" if !password_salt
    raise "Password must have length>0" if pass.length<1
    raise "Password Salt must have length>0" if password_salt.length<1
    Digest::SHA2.hexdigest(pass+password_salt)
  end

  def self.make_random_string( len )
    raise "Length should be between 1 and 71" if len<1 or len>71
    #gen a random password conststing of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end


end

