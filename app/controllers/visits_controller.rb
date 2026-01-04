class VisitsController < ApplicationController
  before_action :require_login
  before_action :set_visit, only: [:edit, :update, :destroy]

  def index
    @visits = current_user.visits.includes(:country).ordered
  end

  def new
    @visit = current_user.visits.build
    @countries = Country.order(:name)
  end

  def create
    @visit = current_user.visits.build(visit_params)

    if @visit.save
      redirect_to dashboard_path, notice: "Visit added successfully!"
    else
      @countries = Country.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @countries = Country.order(:name)
  end

  def update
    if @visit.update(visit_params)
      redirect_to dashboard_path, notice: "Visit updated successfully!"
    else
      @countries = Country.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @visit.destroy
    redirect_to dashboard_path, notice: "Visit deleted successfully!"
  end

  private

  def set_visit
    @visit = current_user.visits.find(params[:id])
  end

  def visit_params
    params.require(:visit).permit(:country_id, :start_date, :end_date, :notes, :purpose)
  end
end
