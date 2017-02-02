class Account < ActiveRecord::Base


  validates_length_of :name, :within => 3..40

  validates_length_of :fullname, :within => 3..40

  validates_presence_of :name, :fullname, :email

  validates_uniqueness_of :name, :fullname, :email

  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i ,
    :message => "email address is invalid"

  validates_numericality_of :nr_logins, :only_integer=>true, :greater_than_or_equal_to=>0

  validates_presence_of :nr_logins
  
  

  def GetDisplayName
    "#{self.fullname} (#{self.name})"
  end


  def self.GetDisplayNameById( accountId )
    a = Account.find( accountId )
    a.GetDisplayName
  end



end
