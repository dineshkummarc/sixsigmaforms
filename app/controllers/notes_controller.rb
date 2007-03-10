class NotesController < ApplicationController
  # before_filter :validate_doctor_and_form_type

  # GET /notes
  # GET /notes.xml
  def index
    @form_instance = FormInstance.find_by_form_type_and_form_id(params[:form_type], params[:form_id])
    @notes = Note.find_by_form_instance_id(@form_instance.id)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @notes.to_xml }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @note.to_xml }
    end
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1;edit
  def edit
#Validate that the note relates to the form being accessed?
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    @note.form_instance = current_form_instance #Is this all that's needed to populate form_type and form_id?
    @note.author = current_user
    respond_to do |format|
      if @note.save
        flash[:notice] = 'Note was successfully created.'
        format.html { redirect_to forms_url(:action => 'draft', :form_type => params[:form_type], :id => params[:form_id]) }
        format.xml  { head :created, :location => forms_url(:action => 'draft', :form_type => params[:form_type], :id => params[:form_id]) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors.to_xml }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])
    @note.form_instance = current_form_instance #Is this all that's needed to populate form_type and form_id?
    @note.author = current_user
    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to forms_url(:action => 'draft', :form_type => params[:form_type], :id => params[:form_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors.to_xml }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to forms_url(:action => 'draft', :form_type => params[:form_type], :id => params[:form_id]) }
      format.xml  { head :ok }
    end
  end
end
