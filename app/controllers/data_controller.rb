require Rails.root.join 'lib/weka/arff_parser.rb'

class DataController < ApplicationController
  # GET /data
  # GET /data.json
  def index
    @data = Datum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end

  # GET /data/1
  # GET /data/1.json
  def show
    @datum = Datum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @datum }
    end
  end

  # GET /data/new
  # GET /data/new.json
  def new
    @datum = Datum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @datum }
    end
  end

  # GET /data/1/edit
  def edit
    @datum = Datum.find(params[:id])
  end

  # POST /data
  # POST /data.json
  # TODO(ushadow): Handle invalid file.
  def create
    uploaded_io = params[:data_file]
    filename = uploaded_io.original_filename
    if filename.end_with? '.arff'
      out_file = File.join ConfigVar[:data_dir], 
      File.open(out_file, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      content = ArffParser.parse_file out_file
      @datum = Datum.new :file_name => uploaded_io.original_filename,
                    :examples => content[:examples],
                    :num_examples => content[:examples].size,
                    :features => content[:features],
                    :num_features => content[:features].size,
                    :relation_name => content[:relation]
    end
    
    respond_to do |format|
      if @datum && @datum.save
        format.js
      else
        format.js 
      end
    end
  end

  # PUT /data/1
  # PUT /data/1.json
  def update
    @datum = Datum.find(params[:id])

    respond_to do |format|
      if @datum.update_attributes(params[:datum])
        format.html { redirect_to @datum, notice: 'Datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data/1
  # DELETE /data/1.json
  def destroy
    @datum = Datum.find(params[:id])
    @datum.destroy

    respond_to do |format|
      format.html { redirect_to data_url }
      format.json { head :no_content }
    end
  end
  
  # XHR GET /data/choose
  # XHR GET /data/choose.json
  def choose
    @datum = Datum.find(params[:trial_datum_id])
    
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @datum && @datum.chart_data }
    end
  end
end
