module API
  class BaseController < ApplicationController

    rescue_from StandardError, with: :runtime_exception
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActionController::ParameterMissing, with: :parameter_missing

    respond_to :xml, :json

    SUCCESS ="success"
    ERROR = "error"
    LINE_SEPARATOR = "\r\n"

    protected

    def respond(response_hash)
      respond_to do |format|
        format.xml { render :xml => response_hash.to_xml(root: "Response"), status: response_hash.delete(:status)}
        format.json { render :json => response_hash, status: response_hash.delete(:status)}
      end
    end
    
    def record_not_found(error)
      response = {api_status: ERROR}
      response[:status] = :not_found
      response[:error] = [error.message]
      respond(response)
    end

    def record_invalid(error)
      response = {api_status: ERROR}
      response[:error] = [error.message]
      response[:status] = :unprocessable_entity
      respond(response)
    end

    def parameter_missing(error)
      response = {api_status: ERROR}
      response[error.param] = [l("parameter.required")]
      response[:status] = :bad_request
      respond(response)
    end

    def runtime_exception(error)
      Rails.logger.fatal("Something went wrong: #{error.message}: #{error.backtrace.join("\n")}")
      response = {api_status: ERROR}
      if error.is_a?(ParametersMissingException)
        response[:error] = [error.message_hash]
        response[:status] = :bad_request
      else
        response[:error] = [error.message]
        response[:status] = :internal_server_error
      end
      respond(response)
    end
  end
end
