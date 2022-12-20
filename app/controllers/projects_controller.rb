# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show welcome]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @projects = Project.order(id: :desc).page(params[:page])
  end

  def show; end

  def welcome; end

  private

  def set_project
    @project = Project.find_by_hashid!(params[:id])
  end
end
