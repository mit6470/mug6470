class ProjectsController < ApplicationController
  # TODO(ushadow): handle the case when user is not logged in.
  before_filter :ensure_logged_in, :only => [:index, :new]
  
  def ensure_logged_in
    bounce_user unless current_user
  end
  private :ensure_logged_in
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects || []

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new :profile => current_user.profile, 
                           :name => "New project"
    
    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_url(@project), notice: 'New project created.'}
      else
        format.html { render action: "index" }
      end
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end
  
  # TODO(ushadow): Delete unused methods.

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
