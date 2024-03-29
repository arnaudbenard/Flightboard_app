require 'rest-client'
require 'json'

module Crocodoc
  extend self
  # Crocodoc's API's base URL
  API_URL = "https://v2.crocodoc.com/api/v2"

  # These options are your preferred defaults that will be passed to various
  # API methods, so that you don't have to pass the same things in each time.
  # Any of these options can be overridden when calling an API method by
  # simply passing the option to the method with a different value.
  API_OPTIONS = {
    # Your API token
    :token => "NpQg9r4l3ekizv5sETWdG8V2",

    # When uploading in async mode, a response is returned before conversion begins.
    :async => false,

    # Documents uploaded as private can only be accessed by owners or via sessions.
    :private => false,

    # When downloading, should the document include annotations?
    :annotated => false,

    # Can users mark up the document? (Affects both #share and #get_session)
    :editable => true,

    # Whether or not a session user can download the document.
    :downloadable => true
  }

  # "Upload and convert a file. This method will try to convert a file that has
  #  been referenced by a URL or has been uploaded via a POST request."
  def upload(url_or_file, options = {})
    if url_or_file.is_a? String
      options.merge! :url => url_or_file
    else
      options.merge! :file => url_or_file
    end
    _shake_and_stir_params(options, :url, :file, :title, :async, :private, :token)

    _request("/document/upload", (options[:file] ? :post : :get), options)
  end

  # "Check the conversion status of a document."
  def status(*uuids)
    options = {}
    options.merge! uuids.pop if uuids.last.is_a? Hash
    options.merge! :uuids => uuids.join(",")
    _shake_and_stir_params(options, :uuids, :token)

    _request("/document/status", :get, options)
  end

  # "Delete an uploaded file."
  def delete(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :token)

    _request("/document/delete", :get, options)
  end

  # "Download an uploaded file with or without annotations."
  def download(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :annotated, :token)

    _request_raw("/document/download", :get, options)
  end

  # "Creates a new 'short ID' that can be used to share a document."
  def share(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :editable, :token)

    _request("/document/share", :get, options)
  end

  # "Clones an uploaded document. Document annotations are not copied."
  def clone(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :token)
    
    _request("/document/clone", :get, options)
  end

  # "Creates a session ID for session-based document viewing. Each session ID
  #  may only be used once."
  def get_session(uuid, options = {})
    options.merge! :uuid => uuid
    _shake_and_stir_params(options, :uuid, :token, :downloadable, :editable, :name)

    _request("/session/get", :get, options)
  end

  # "View an embedded document. This URL returns a web page that can be embedded
  #  within an iframe."
  def embeddable_viewer_url(shortId)
    "http://crocodoc.com/#{shortId}?embedded=true"
  end

  # "View a document using session-based viewing. Session-based viewing enables
  #  the embedding of private documents. To obtain session IDs, use the
  #  session/get API method."
  def session_based_viewer_url(sessionId)
    "https://crocodoc.com/view/?sessionId=#{sessionId}"
  end

  private

  def _request(path, method, options)
    response_body = _request_raw(path, method, options)

    if response_body == false
      false
    elsif response_body == "true"
      # JSON.parse has a problem with parsing the string "true"...
      true
    else
      JSON.parse(response_body, :symbolize_names => true)
    end
  end

  def _request_raw(path, method, options)
    begin
      response = case method
      when :get
        RestClient.get(API_URL + path, :params => options)
      when :post
        RestClient.post(API_URL + path, options)
      else
        raise ArgumentError, "method must be :get or :post"
      end

      response.code == 200 ? response.to_str : false
    rescue RestClient::InternalServerError
      false
    end
  end

  def _shake_and_stir_params(params, *whitelist)
    # Mix and stir the two params hashes together.
    params.replace API_OPTIONS.merge(params)

    # Shake out the unwanted params.
    params.keys.each do |key|
      params.delete(key) unless whitelist.include? key
    end
  end
end
