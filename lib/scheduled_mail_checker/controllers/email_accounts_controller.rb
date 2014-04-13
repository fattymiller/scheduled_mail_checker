module ScheduledMailChecker
  class EmailAccountsController < BaseJump::PluginsController
    load_and_authorize_resource except: [:create]

    def create
      email_account = ScheduledMailChecker::EmailAccount.new(email_accounts_params)
      
      respond_to do |format|
        if email_account.save(email_accounts_params)
          format.html { redirect_to email_account, notice: 'Email account successfully created.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: email_account.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      params.delete(:password) if params[:password].blank?
    
      respond_to do |format|
        if @email_account.update(email_accounts_params)
          format.html { redirect_to @email_account, notice: 'Email account successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @email_account.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      # TODO
    end

    private

    def email_accounts_params
      params.require(:scheduled_mail_checker_email_account).permit(:name, :username, :password, :server, :port, :ssl, :check_delay, :handler_ids => [])
    end
  end
end