module Tayler
  class ApplicationController < ActionController::Metal
    include ActionController::Rendering
    include ActionController::Renderers::All

    def route
      action_name = request.env['HTTP_SOAPACTION']
      begin
        handler = Tayler::Server.find_action(action_name)
        render :xml => handler.new(request.body).run
      rescue Faults::SoapError => e
        render :xml => e
      rescue => e
        render :xml => Faults::CriticalError.new(e)
      end
    end
  end
end
