class CompetencyFrameworksController < ApplicationController
  def show
    fetcher = CompetencyFrameworkFetcher.new(id: params[:id])

    send_data fetcher.body, type: fetcher.content_type, disposition: :inline
  end
end
