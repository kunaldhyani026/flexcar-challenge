# frozen_string_literal: true

require 'ecommerce/item_handler'

# Controller responsible for managing promotions.
class ItemsController < ApplicationController
  before_action :validate_params

  # Just adding code structure for understanding, as implementation is out of scope for current timelines

  def add
    # to-do [OUT OF SCOPE for current assignment timeline and requirement]
    # render_response(Ecommerce::ItemHandler.new(params[:user_id]).create_item(params)
  end

  def edit
    # to-do [OUT OF SCOPE for current assignment timelines and requirement]
    # render_response(Ecommerce::ItemHandler.new(params[:user_id]).update_item(params)
  end

  private

  # Validates input params for add and edit action, returns error to user for bad input
  def validate_params
    # to-do
  end
end

