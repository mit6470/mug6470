class TrialsController < ApplicationController
  # TODO(ushadow): handle the case when user is not logged in.
  before_filter :ensure_logged_in, :only => [:index, :new, :create]
  
  def ensure_logged_in
    bounce_user unless current_user
  end
  private :ensure_logged_in
  
  # XHR DELETE /trials/1
  def destroy
    @trial = Trial.find(params[:id])
    @trial.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
  # XHR POST /trials.json
  def create
    @trial = Trial.new(params[:trial])
    @trial.datum_id = params[:trial_datum_id]
    @trial.classifier_id = params[:trial_classifier_id]
    features = params[:selected_features]
    @trial.selected_features = features && features.map(&:to_i)
    project_id = params[:project_id]
    max_trial_id = Trial.where(:project_id => project_id).maximum(:id) || 0
    @trial.name = "Trial-#{max_trial_id + 1}"
    @trial.project_id = project_id
    @trial.run
    
    respond_to do |format|
      if @trial.save
        format.json { render json: @trial, status: :created }
      else 
        format.json { render json: @trial.errors, status: :unprecessable_entity }
      end
    end
  end
  
  # XHR GET projects/1/trials/1
  # XHR GET /trials/1.json
  def show
    @trial = Trial.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @trial }
    end
  end

  # TODO(ushadow): Delete unused methods below.

  # GET /trials
  # GET /trials.json
  def index
    @trials = Trial.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trials }
    end
  end

  # GET /trials/new
  # GET /trials/new.json
  def new
    @trial = Trial.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trial }
    end
  end

  # GET /trials/1/edit
  def edit
    @trial = Trial.find(params[:id])
  end

  # PUT /trials/1
  # PUT /trials/1.json
  def update
    @trial = Trial.find(params[:id])

    respond_to do |format|
      if @trial.update_attributes(params[:trial])
        format.html { redirect_to trials_url, notice: 'Trial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trial.errors, status: :unprocessable_entity }
      end
    end
  end
end
