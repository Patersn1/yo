class FavoriteOpportunitiesController < ApplicationController
  before_action :set_favorite_opportunity, only: [:destroy]

  def new
    @favorite_opportunity = FavoriteOpportunity.new
  end

  def create
    @favorite_opportunity = FavoriteOpportunity.new(favorite_opportunity_params)
    @favorite_opportunity.user_id = current_user.id

    @opportunity = Opportunity.find(favorite_opportunity_params[:opportunity_id])
    @favorite_opportunity.opportunity_id = @opportunity.id

    respond_to do |format|
      if @favorite_opportunity.save
        format.html { redirect_to opportunities_path, notice: 'You have successfully favorited ' + @opportunity.name + ' by ' + @opportunity.organization.name + '!'}
        format.json { render :show, status: :created, location: @favorite_opportunity }
      else
        format.html { redirect_to opportunities_path }
        format.json { render json: @favorite_opportunity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @opportunity = @favorite_opportunity.opportunity
    @favorite_opportunity.destroy
    respond_to do |format|
      format.html { redirect_to opportunities_path, notice: 'You have sucessfully unfavorited from ' + @opportunity.name + ' by ' + @opportunity.organization.name + '!'}
      format.json { head :no_content }
    end
  end
  
  private
    def set_favorite_opportunity
      @favorite_opportunity = FavoriteOpportunity.find(params[:id])
    end

    def favorite_opportunity_params
      params.require(:favorite_opportunity).permit(:user_id, :opportunity_id)
    end
end