class AirportPolicy < ApplicationPolicy

  def index?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'airport read'
  end

  def show?
    index?
  end

  def create?
    new?
  end

  def new?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'airport create'
  end

  def update?
    edit?
  end

  def edit?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'airport update'
  end

  def destroy?
    @user.nil? ? group = Group.find_by(name: 'Public') : group = @user.group
    group.permissions.pluck('name').include? 'airport delete'
  end

  def permitted_attributes
    [ :icao, :name, :show_metar ]
  end
end