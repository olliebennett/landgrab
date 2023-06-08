# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :set_team, only: %i[show]

  def show
    log_event_mixpanel('Teams: Show', { authed: user_signed_in?, team: @team.slug })
  end

  private

  def set_team
    @team = Team.find_by!(slug: params[:id])
  end
end
