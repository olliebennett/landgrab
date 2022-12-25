# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show welcome]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    log_event_mixpanel('Projects: Index', { authed: user_signed_in? })
    @projects = Project.order(id: :desc).page(params[:page])
  end

  def show
    log_event_mixpanel('Projects: Show', { authed: user_signed_in?, project: @project })
  end

  def welcome
    log_event_mixpanel('Projects: Welcome', { authed: user_signed_in?, project: @project })
  end

  private

  def set_project
    @project = Project.find_by_hashid!(params[:id])
  end
end
