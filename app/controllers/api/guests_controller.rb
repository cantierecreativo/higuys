module Api
  class GuestsController < BaseController
    before_filter :retrieve_guest

    def status
      @guest.update_attributes(status_message: params[:status_message])
      respond_with @guest
    end

    private

    def retrieve_guest
      @guest ||= Guest.find(session[:guest_id])
    end
  end
end
