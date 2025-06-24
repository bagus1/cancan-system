class Admin::AbilityPermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_ability_permission, only: [:show, :edit, :update, :destroy]

  def index
    @ability_permissions = AbilityPermission.all.order(:subject, :action)
    @grouped_permissions = @ability_permissions.group_by(&:subject)
  end

  def show
  end

  def new
    @ability_permission = AbilityPermission.new
    @ability_permission.subject = params[:subject] if params[:subject].present?
    @available_subjects = get_available_subjects
    @available_actions = get_available_actions
  end

  def create
    @ability_permission = AbilityPermission.new(ability_permission_params)
    
    if @ability_permission.save
      redirect_to admin_ability_permissions_path, notice: 'Permission was successfully created.'
    else
      @available_subjects = get_available_subjects
      @available_actions = get_available_actions
      render :new
    end
  end

  def edit
    @available_subjects = get_available_subjects
    @available_actions = get_available_actions
  end

  def update
    if @ability_permission.update(ability_permission_params)
      redirect_to admin_ability_permissions_path, notice: 'Permission was successfully updated.'
    else
      @available_subjects = get_available_subjects
      @available_actions = get_available_actions
      render :edit
    end
  end

  def destroy
    @ability_permission.destroy
    redirect_to admin_ability_permissions_path, notice: 'Permission was successfully deleted.'
  end

  private

  def set_ability_permission
    @ability_permission = AbilityPermission.find(params[:id])
  end

  def ability_permission_params
    params.require(:ability_permission).permit(:subject, :action, :description)
  end

  def ensure_admin
    redirect_to root_path unless current_user&.admin?
  end

  def get_available_subjects
    # Get existing subjects plus common Rails models
    existing_subjects = AbilityPermission.distinct.pluck(:subject)
    common_subjects = %w[Order User Role AbilityPermission UserRole RoleAbility]
    (existing_subjects + common_subjects).uniq.sort
  end

  def get_available_actions
    # Get existing actions plus common CRUD actions
    existing_actions = AbilityPermission.distinct.pluck(:action)
    common_actions = %w[read create update destroy manage index show new edit process_order]
    (existing_actions + common_actions).uniq.sort
  end
end 