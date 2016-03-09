module Api
  class BaseController < ApplicationController

    rescue_from StandardError, with: :runtime_exception
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    respond_to :xml, :json
    skip_before_action :verify_authenticity_token


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
      response = {}
      response[:status] = :not_found
      response[:error] = [error.message]
      respond(response)
    end

    def record_invalid(error)
      response = {}
      response[:error] = [error.message]
      response[:status] = :unprocessable_entity
      respond(response)
    end


    def runtime_exception(error)
      response = {}
      Rails.logger.fatal("Something went wrong: #{error.message}: #{error.backtrace.join("\n")}")
      response[:error] = [error.message]
      response[:status] = :internal_server_error
      respond(response)
    end
  end
end
