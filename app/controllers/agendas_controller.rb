class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]
  before_action :authority, only: [:destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

  def destroy
    @agenda.destroy
    members = @agenda.team.members
    members.each do |member|
      AgendaMailer.agenda_delete_mail(member.email).deliver
    end
    redirect_to dashboard_url, notice: I18n.t('views.messages.delete_agenda')
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def authority
    unless current_user == @agenda.user || current_user == @agenda.team.owner
      redirect_to dashboard_url, notice: I18n.t('views.messages.do_not_have_right')
    end
  end
end
