class HmdsController < ApplicationController
  def index
    @hmds = Hmd.all.order("announced_at desc, name desc")

    respond_to do |format|
      format.html
      format.json { render :json => @hmds }
    end
  end

  def edit
    @hmds = Hmd.all.order("announced_at desc, name desc")
  end

  def update
    @hmd = Hmd.find(params[:id])
    @hmd.state = params[:hmd][:state]
    
    respond_to do |format|
      format.json do
        if @hmd.save
          
          render :json => @hmd
        else
          render :json => {errors: @hmd.errors.messages}, :status => 422
        end
      end
    end
    # redirect_to hmds_path
  end
end
