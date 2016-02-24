class SearchController < ApplicationController
  def index
  end

  def results
    query = params['query']
    tw_api = TwitterApi.new
    session[:search_history] ||= []
    results = tw_api.search(query)
    @result_texts = results.collect(&:text)
    session[:search_history] << [query, DateTime.current, @result_texts]
  end
end
