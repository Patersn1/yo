class FavoriteOrganizationsController < ApplicationController
    before_action :set_favorite_organization, only: [:destroy]
  
    def new
      @favorite_organization = FavoriteOrganization.new
    end
  
    def create
      @favorite_organization = FavoriteOrganization.new(favorite_organization_params)
      @favorite_organization.user_id = current_user.id
  
      @organization = Organization.find(favorite_organization_params[:organization_id])
      @favorite_organization.organization_id = @organization.id
  
      respond_to do |format|
        if @favorite_organization.save
          format.html { redirect_to organizations_path, notice: 'You have successfully favorited ' + @organization.name + '!'}
          format.json { render :show, status: :created, location: @favorite_organization }
        else
          format.html { redirect_to organizations_path }
          format.json { render json: @favorite_organization.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @organization = @favorite_organization.organization
      @favorite_organization.destroy
      respond_to do |format|
        format.html { redirect_to organizations_path, notice: 'You have sucessfully unfavorited from ' + @organization.name + '!'}
        format.json { head :no_content }
      end
    end
    
  
    private
      def set_favorite_organization
        @favorite_organization = FavoriteOrganization.find(params[:id])
      end
  
      def favorite_organization_params
        params.require(:favorite_organization).permit(:user_id, :organization_id)
      end
  end