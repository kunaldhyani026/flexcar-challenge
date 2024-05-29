# frozen_string_literal: true

require 'ecommerce/promotion_handler'

# Controller responsible for managing promotions.
class PromotionsController < ApplicationController
  before_action :validate_params

  # Just adding code structure for understanding, as implementation is out of scope for current timelines of 48 hours

  def add
    # to-do [OUT OF SCOPE for current assignment timelines and requirement]
    # render_response(Ecommerce::PromotionHandler.new(params[:user_id]).create_promotion(params)
  end

  def edit
    # to-do [OUT OF SCOPE for current assignment timelines and requirement]
    # render_response(Ecommerce::PromotionHandler.new(params[:user_id]).update_promotion(params)
  end

  private

  # Validates input params for add and edit action, returns error to user for bad input
  def validate_params
    # to-do
  end
end

