class AccountsController < ApplicationController

  
  before_action :check_logged_in, :except=>[ :login, :signup ]

  before_action :set_account, :only=>[:home, :password]
  #before_action :set_account_secret, only: [:login]

    

  def index
    redirect_to :action=>'home'
  end


  def home
    @title = "Account Home"
    @account = Account.find(session[:user])
  end


  def password

    if request.patch?
      # a PATCH
      
      #was the old password entered correct?
      account = Account.find(session[:user])
      name = account.name
      pass = params[:account_secret][:password_old]
      @account_secret2 = AccountSecret.authenticate(name,pass)

      if ! @account_secret2
        # old password did not match
        flash[:error] = "Old password is wrong, please reenter"
        flash[:test] = "case C"
      elsif params[:account_secret][:password] != params[:account_secret][:password_confirmation]
        # make sure password and password_confirm are identical
        flash[:error] = "The password and its confirmation are not identical. Please reenter."
      else
        #all seems ok so far, now try changing the password in DB
        @account_secret2.password = params[:account_secret][:password]
        begin
          @account_secret2.save!
          flash[:notice] = "The password was changed successfully."
          flash.delete( :error )
        rescue => ex
          flash[:error] = ex.message
        end
      end
    else
      # a GET
    end

    @account_secret = AccountSecret.find(session[:user])

  end




  def login

    if session[:user]
      redirect_to :action=>'home'
    end

    if request.post?
      #is a POST

      if ! params[:user]
        #TODO: may need more logic for this case
        return;
      end
      
      account_secret = AccountSecret.authenticate( params[:user][:name], params[:user][:password] )
      if account_secret
        account = Account.find( account_secret[:account_id] )
        #flash[:debug]="case A"
        session[:user] = account.id
        account.nr_logins += 1
        account.save!
        flash[:notice] = "Login Successful"
        redirect_to :action=>'home'
        return
      else
        #flash[:debug]="case B"
        flash[:error] = "Login unsuccessful";
        return
        #if session[:return_to]
        #  flash[:debug]="case C"
        #  redirect_to session[:return_to]
        #  return
        #else
          #flash[:debug]="case D"
        #  redirect_to :action=>'home'
        #  return
        #end
      end
    else
      #is a GET
      #flash[:debug]="case E"
      session[:return_to] = request.url
      #session[:login_post_to] = '/accounts/login'
    end

  end

  
  def logout

    session[:user] = nil
    flash[:notice] = 'Logged out'
    redirect_to :action=>'login'

  end


  def signup

    @title = "Signup"
    if request.post?

      # a POST
      
      if ! params[:signup]
        #TODO: may need more logic for this case
        @account = Account.new
        return
      end

      # check if account with such name already exists
      a = Account.where( :name=>params[:signup][:name] ).first()
      if a
        flash[:error] = "User with name '#{params[:signup][:name]}' already exists. Please choose another user name."
        params[:password] = ""
        params[:password_confirmation] = ""
        # TODO: when form is redisplayed, it would be nice to pre-populate values automatically which were already entered. might need a new model for that.
        return
      end

      @account2 = Account.new()
      @account2.name     = params[:signup][:name]
      @account2.fullname = params[:signup][:fullname]
      @account2.email    = params[:signup][:email]

      if ! @account2.save
        flash[:error] = "Error saving the account: #{@account2.errors.values}"
        return
      end

      @account = Account.where( :name=>params[:signup][:name] ).first()

      @account_secret = AccountSecret.new()
      @account_secret.account_id            = @account.id
      @account_secret.account_name          = params[:signup][:name]
      @account_secret.password              = params[:signup][:password]
      @account_secret.password_confirmation = params[:signup][:password_confirmation]
      @account_secret.save

      if ! @account_secret.save
        flash[:error] = "Error saving the account (part 2): #{@account.errors.values}"
        @account.clear_password!
        return
      end

      session[:user] = @account.id
      flash[:notice] = "Account #{@account.name} created!"
      flash.delete( :error )
      redirect_to :action => 'home'

    else
      # a GET
      #if ! params[:user]
      @account = Account.new
      #end
    end

  end

  
  def user
    begin
      @account = Account.find( params[:id] )
    rescue => ex
      flash[:error] = "Problem getting account: #{ex.message}"
    end
    #if !@account or !@account.errors.empty?
  end


  def users
    @accounts = Account.all
  end
  
  

private

  def check_logged_in
    if ! session[:user]
      session[:return_to] = request.url
      redirect_to :action=>'login'
      return false
    else
      true
    end
  end

  def set_account
    if session[:user]
      @account = Account.find( session[:user] )
    end
  end

  def set_account_secret
    if session[:user]
      @account_secret = AccountSecret.get_by_user_id( session[:user] )
    end
  end

  
end


# logger.debug "A debug message"
# logger.info "A info message"
# logger.error "An error"
