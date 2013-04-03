module Tayler
  class ApplicationController < ActionController::Metal
    include ActionController::Rendering
    include ActionController::Renderers::All

    if defined?(Airbrake)
      require 'airbrake/rails/controller_methods'
      include Airbrake::Rails::ControllerMethods
    end

    def route
      action_name = request.env['HTTP_SOAPACTION']
      begin
        handler = Tayler::Server.find_action(action_name)
        render :xml => handler.new(request.body).run
      rescue Faults::SoapError => e
        render :xml => e
      rescue => e
        if Rails.env.production?
          notify_airbrake(e) if defined?(Airbrake)
          render :xml => Faults::CriticalError.new(e)
        else
          raise e
        end
      end
    end
  end
end
