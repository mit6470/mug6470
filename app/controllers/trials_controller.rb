class TrialsController < ApplicationController
  # GET /trials
  # GET /trials.json
  def index
    @trials = Trial.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trials }
    end
  end

  # GET /trials/1
  # GET /trials/1.json
  def show
    @trial = Trial.find(params[:id])
    @output = @trial.run
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trial }
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

  # POST /trials
  # POST /trials.json
  def create
    @trial = Trial.new(params[:trial])
    @trial.datum_id = params[:datum_id]
    @trial.classifier_id = params[:classifier_id]
    
    respond_to do |format|
      if @trial.save
        format.html { redirect_to @trial, notice: 'Trial was successfully created.' }
        format.json { render json: @trial, status: :created, location: @trial }
      else
        format.html { render action: "new" }
        format.json { render json: @trial.errors, status: :unprocessable_entity }
      end
    end
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

  # DELETE /trials/1
  # DELETE /trials/1.json
  def destroy
    @trial = Trial.find(params[:id])
    @trial.destroy

    respond_to do |format|
      format.html { redirect_to trials_url }
      format.json { head :no_content }
    end
  end
  
end
