module Tayler
  class ApplicationController < ActionController::Metal
    include ActionController::Rendering
    include ActionController::Renderers::All
    def route
      action_name = request.env['HTTP_SOAPACTION']
      handler = Tayler.find_action(action_name)
      response = handler.new(request.body).run
      render :xml => response
    end
  end
end
