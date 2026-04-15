
class SearchController < ApplicationController
  def index
    # Get list of distinct school years of the volunteers
    @years = User.order(:year).distinct.pluck(:year)
    # Get list of distinct majors of the volunteers
    @majors = User.order(:major).distinct.pluck(:major)

    if params[:keywords].present?
      # Get any keywords from search box
      @keywords = params[:keywords]
      # Use keywords to create new search term object
      volunteer_search_term = VolunteerSearchTerm.new(@keywords)

      # If any item chosen from dropdown list of years
      # Then add clause to search term to find volunteers in that year
      if params[:year].present?
        @year = params[:year]
        volunteer_search_term.where_clause << " AND year LIKE '#{@year}'"
      end

      # If any item chosen from dropdown list of majors
      # Then add clause to search term to find volunteers in that major
      if params[:major].present?
        @major = params[:major]
        volunteer_search_term.where_clause << " AND major LIKE '#{@major}'"
      end

      # Get all volunteers who match search criteria
      @volunteers = User.where(
        volunteer_search_term.where_clause,
        volunteer_search_term.where_args).
      order(volunteer_search_term.order)
      elsif params[:year].present? && !params[:major].present?
        # Gets all volunteers who are in a particular year when no major or keywords provided
        @year = params[:year]
        @volunteers = User.where("admin = false AND organization_id IS NULL AND year LIKE '#{@year}'")
      elsif params[:major].present? && !params[:year].present?
        # Gets all volunteers who are in a particular major when no year or keywords provided
        @major = params[:major]
        @volunteers = User.where("admin = false AND organization_id IS NULL AND major LIKE '#{@major}'")
      elsif params[:year].present? && params[:major].present?
        # Gets all volunteers who are in a particular year and major when no keywords provided
        @year = params[:year]
        @major = params[:major]
        @volunteers = User.where("admin = false AND organization_id IS NULL AND year LIKE '#{@year}' AND major LIKE '#{@major}'")
      else
        # Gets all voulunteers in database when no search paramaters provided
        @volunteers = User.where("admin = false AND organization_id IS NULL")
    end
  end
end
