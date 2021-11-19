class ApplicationController < ActionController::API
    rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
        error = {}
        error[parameter_missing_exception.param] = ['parameter is required']
        response = { errors: [error] }
        render json: response, status: :unprocessable_entity
    end

    rescue_from(JSON::ParserError) do
        error = {}
        error["message"] = ['Form Value invalid as JSON']
        response = { errors: [error] }
        render json: response, status: :bad_request
    end

    rescue_from(FormSpecParseService::InvalidFormSpecError) do |format_error|
        error = {}
        error["message"] = [format_error]
        response = { errors: [error] }
        render json: response, status: :bad_request
    end

    rescue_from(ActiveRecord::RecordNotUnique) do
        error = {}
        error["message"] = ["There's already an object with the same key in Database"]
        response = { errors: [error] }
        render json: response, status: :conflict
    end

    rescue_from(ActiveRecord::RecordNotFound) do |error_message|
        error = {}
        error["message"] = [error_message]
        response = { errors: [error] }
        render json: response, status: :not_found
    end
end
