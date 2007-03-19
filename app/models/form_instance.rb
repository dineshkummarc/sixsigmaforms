class FormInstance < ActiveRecord::Base
  belongs_to :user       #Uses column user_id
  belongs_to :doctor     #Uses column doctor_id
  belongs_to :patient    #Uses column patient_id
  belongs_to :form_type  #Uses column form_type_id
  belongs_to :form_data, :polymorphic => true, :dependent => :destroy #(, :extend => ...)  #Uses columns form_data_type, form_data_id
  has_many :notes, :dependent => :destroy

#Creating a new FormInstance:
#  FormInstance.new(:doctor => Doctor, :user => current_user, :patient => Patient, :form_type => FormType, [[:form_data => AUTO-CREATES NEW]])

# Automagically create the form data record whenever a FormInstance is created, and then automagically destroy it when the FormInstance is destroyed.
# The form data record will always be tied to self.form_data
  def initialize(args)
    self.form_data = args[:form_type].new unless !(args.kind_of? Hash) or args[:form_type].nil?
    args[:form_type] = FormType.find_by_name(args[:form_type].to_s)
    super(args)
  end

  def status
    self.status_number.number_to_status
  end

  def status=(value)
    self.status_number = value.status_to_number || self.status_number
  end
  def self.status_plural(name)
    stat = name.kind_of?(Fixnum) ? name : name.status_to_number
    return nil if stat.nil?
    ['drafts', 'submitted forms', 'reviewed forms', 'accepted forms'][stat-1]
  end
  def status_plural(name)
    FormInstance.status_plural(name)
  end

  # alias_method :vanilla_destroy, :destroy
  # def destroy
  # # Destroy the corresponding form data record
  #   # frm = self.form_type.form_type.constantize.find(self.form_id)
  #   # frm.destroy unless frm.blank?
  # # Destroy the tied patient record if this is the only form attached to the patient
  #   self.patient.destroy if self.patient.form_instances.count == 1
  # # Finally, destroy the FormInstance
  #   return self.vanilla_destroy(*args)
  # end

end
