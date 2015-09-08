class EntitiesController < ApplicationController
  before_action -> { authorize :entity }, except: [:show]
  before_action -> { authorize entity }, only: :show

  helper_method :entity, :entities, :search

  protected

  def entity
    @entity ||= Entity.find(params[:id])
  end

  def entities
    # TODO: Add paging w/ kaminari
    # @entities ||= search.result.decorate
    @entities ||= Entity.all.decorate
  end

  def search
    @search ||= Entity.order { name }.ransack(params[:q])
  end
end
