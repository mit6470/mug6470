require Rails.root.join 'lib/weka/arff_parser.rb'

class DataController < ApplicationController
  before_filter :ensure_logged_in, :only => [:create]
  
  def ensure_logged_in
    bounce_user unless current_user
  end
  
  # GET /data
  # GET /data.json
  def index
    @data = Datum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data }
    end
  end

  # XHR GET /data/1
  # GET /data/1.json
  def show
    @datum = Datum.find(params[:id])
    # Indices are 1-based.
    example_ind = params[:examples].map(&:to_i)
    if @datum
      @examples = example_ind.map { |i| @datum.examples[i - 1] }
    end
    
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @examples }
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
  private :new

  # GET /data/1/edit
  def edit
    @datum = Datum.find(params[:id])
  end
  private :edit

  # POST /data
  # POST /data.json
  # TODO(ushadow): Check file type before copying. Save file in another user 
  #     data directory. Only save data for a saved project. Check if ID feature
  #     is present.
  def create
    uploaded_io = params[:data_file]
    filename = uploaded_io.original_filename

    if filename.end_with?('.arff') && 
      uploaded_io.content_type == 'application/octet-stream' 
      
      tempfile = uploaded_io.tempfile
      content = ArffParser.parse_file tempfile.path
      
      unless content.blank?
        file_dir =  File.join ConfigVar[:user_data_dir], current_user.id.to_s       
        file_path = File.join file_dir, filename
        @datum = Datum.new :file_path => file_path,
                      :examples => content[:examples],
                      :num_examples => content[:examples].size,
                      :features => content[:features],
                      :num_features => content[:features].size,
                      :relation_name => content[:relation],
                      :profile => current_user.profile,
                      :is_tmp => false
       
        if @datum.save
          Dir.mkdir file_dir unless File.exists? file_dir
          FileUtils.cp tempfile.path, file_path
        else
          @error_msg = @datum.errors.full_messages[0] || 'Invalid data file.'
        end
      else
        @error_msg = 'Invalid file format.' 
      end
    else
      @error_msg = 'Invalid file type: must be a .arff file.'
    end
    
    respond_to do |format|
      format.js
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
  private :update

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
  private :destroy
  
  # XHR GET /data/choose
  # XHR GET /data/choose.json
  def choose
    @datum = Datum.find(params[:trial_datum_id])
    
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @datum && @datum.chart_data }
    end
  end
  
  # XHR GET /data/tweet
  # XHR GET /data/tweet.json
  def tweet 
    # Get 30 tweets, keep at most 10
    search_term = params[:tweet_search_term]
    statuses = Twitter.search(search_term, {:rpp => 30, :lang => 'en'})
    tweet_list = Array.new()
    # Clean up the tweets
    statuses.each_with_index do |status, i|
      if /RT|http:\S+/ =~ status.text
        next
      end
      text = status.text
      # Convert hashtags
      text.gsub!('#', ' ')
      # Strip emoticons
      text.gsub!(/:\)|:-\)|: \)|:D|=\)|:\(|:-\(|: \(|;3/, '')
      # Sub usernames
      text.gsub!(/@\S+/, 'username')
      # Sub repeated letters
      text.gsub!(/(\w)\1\1/, '\1')
      # Remove non letter, number or whitespace
      text.gsub!(/[^\w\d\s]+/, '')
      # Clean up whitespace
      text.gsub!(/\s+/, ' ')
      text.strip!
      # Force lower case
      text.downcase!
      tweet_list << text
      if tweet_list.length == 10
        break
      end
    end

    #if tweet_list.length == 0
    #end
      
    # Setup a new ARFF file for the tweets
    search_term.gsub!(/\s+/, '-')
    time = Time.now
    timestr = "#{time.hour}-#{time.min}-#{time.sec}"
    filename = "twitter-#{search_term}-#{timestr}.arff"
    if current_user
      file_dir =  File.join ConfigVar[:user_data_dir], current_user.id.to_s       
    else
      file_dir =  ConfigVar[:nouser_data_dir]
    end
    Dir.mkdir file_dir unless File.exists? file_dir
    file_path = File.join file_dir, filename
    test_file = File.new(file_path, 'w')
    if test_file
      test_file.syswrite("@relation twitter-#{search_term}-#{time.hour}-#{time.min}-#{time.sec}\n\n")
      test_file.syswrite("@attribute ID numeric\n")
      test_file.syswrite("@attribute tweet string\n")
      test_file.syswrite("@attribute polarity {negative, positive}\n\n")
      test_file.syswrite("@data\n\n")
      tweet_list.each_with_index do |tweet, i|
        test_file.syswrite("#{i+1}, '#{tweet}', ?\n")
      end
      test_file.close()
    else
      @error_msg = "Couldn't create file #{file_path}"
    end
      
    content = ArffParser.parse_file file_path
    
    unless content.blank?
      @datum = Datum.new :file_path => file_path,
                    :examples => content[:examples],
                    :num_examples => content[:examples].size,
                    :features => content[:features],
                    :num_features => content[:features].size,
                    :relation_name => content[:relation],
                    :is_tmp => true
     
      if not @datum.save
        @error_msg = @datum.errors.full_messages[0] || 'Invalid file format.' 
      end
    else
      @error_msg = 'Invalid search term.' 
    end

    respond_to do |format|
      unless @error_msg
        format.json { render json: @datum, status: :created }
      else
        format.json { render json: @error_msg, status: :unprocessable_entity }
      end
    end
  end
end
