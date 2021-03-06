class UsersController < ApplicationController
  before_filter :login_required, :only=>['index']
  before_filter :user_valid?, :only => ['show', 'edit', 'update', 'destroy']
  
  def index
    @users = User.all
    #@users = User.find(:all, :joins => "left outer join locations on locations.user_id = users.id", :order => "locations.updated_at DESC")
    @users = User.find(:all, :include => :locations, :order => 'locations.updated_at DESC')
    @user = User.find(session[:user_id])
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create  
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user]) && user_valid
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if !@admin
	    session[:user_id] = nil
	    @user = User.find(session[:user_id])
	  end
    respond_to do |format|
      format.html { redirect_to(root_url) }
    end
  end
end
