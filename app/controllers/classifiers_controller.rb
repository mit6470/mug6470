class ClassifiersController < ApplicationController
  # GET /classifiers
  # GET /classifiers.json
  def index
    @classifiers = Classifier.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @classifiers }
    end
  end

  # GET /classifiers/1
  # GET /classifiers/1.json
  def show
    @classifier = Classifier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @classifier }
    end
  end

  # GET /classifiers/new
  # GET /classifiers/new.json
  def new
    @classifier = Classifier.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @classifier }
    end
  end

  # GET /classifiers/1/edit
  def edit
    @classifier = Classifier.find(params[:id])
  end

  # POST /classifiers
  # POST /classifiers.json
  def create
    @classifier = Classifier.new(params[:classifier])

    respond_to do |format|
      if @classifier.save
        format.html { redirect_to @classifier, notice: 'Classifier was successfully created.' }
        format.json { render json: @classifier, status: :created, location: @classifier }
      else
        format.html { render action: "new" }
        format.json { render json: @classifier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /classifiers/1
  # PUT /classifiers/1.json
  def update
    @classifier = Classifier.find(params[:id])

    respond_to do |format|
      if @classifier.update_attributes(params[:classifier])
        format.html { redirect_to @classifier, notice: 'Classifier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @classifier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classifiers/1
  # DELETE /classifiers/1.json
  def destroy
    @classifier = Classifier.find(params[:id])
    @classifier.destroy

    respond_to do |format|
      format.html { redirect_to classifiers_url }
      format.json { head :no_content }
    end
  end
  
end
