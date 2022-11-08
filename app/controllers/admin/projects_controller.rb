# frozen_string_literal: true

module Admin
  class ProjectsController < ApplicationController
    before_action :check_admin
    before_action :set_project, only: %i[show edit update]

    def index
      @projects = Project.order(id: :desc).page(params[:page])
    end

    def show; end

    def new
      @project = Project.new
    end

    def edit; end

    def create
      @project = Project.new(project_params)

      respond_to do |format|
        if @project.save
          format.html { redirect_to admin_project_path(@project), notice: 'Project was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to admin_project_path(@project), notice: 'Project was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    private

    def set_project
      @project = Project.find_by_hashid!(params[:id])
    end

    def project_params
      params.require(:project)
            .permit(
              :title,
              :description,
              :website,
              :hero_image_url,
              :logo_url
            )
    end
  end
end
