class Admin::RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  
  def index
    @roles = Role.includes(:ability_permissions, :users).order(:name)
  end
  
  def show
    @permission_matrix = build_permission_matrix
    @users_with_role = @role.users
  end
  
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(role_params)
    
    if @role.save
      redirect_to admin_role_path(@role), notice: 'Role was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @permission_matrix = build_permission_matrix
    @available_permissions = AbilityPermission.all.group_by(&:subject)
  end
  
  def update
    if @role.update(role_params)
      update_permissions
      redirect_to admin_role_path(@role), notice: 'Role was successfully updated.'
    else
      @permission_matrix = build_permission_matrix
      @available_permissions = AbilityPermission.all.group_by(&:subject)
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @role.users.any?
      redirect_to admin_roles_path, alert: 'Cannot delete role that has users assigned to it.'
    else
      @role.destroy
      redirect_to admin_roles_path, notice: 'Role was successfully deleted.'
    end
  end
  
  def permissions
    @permission_matrix = build_permission_matrix
  end
  
  private
  
  def set_role
    @role = Role.find(params[:id])
  end
  
  def build_permission_matrix
    subjects = AbilityPermission.distinct.pluck(:subject).sort
    actions = AbilityPermission.distinct.pluck(:action).sort
    
    matrix = {}
    subjects.each do |subject|
      matrix[subject] = {}
      actions.each do |action|
        permission = AbilityPermission.find_by(action: action, subject: subject)
        matrix[subject][action] = {
          permission: permission,
          granted: permission && @role.ability_permissions.include?(permission)
        }
      end
    end
    matrix
  end
  
  def update_permissions
    permission_ids = params[:role][:ability_permission_ids] || []
    @role.ability_permissions = AbilityPermission.where(id: permission_ids)
  end
  
  def role_params
    params.require(:role).permit(:name, :description)
  end
end 