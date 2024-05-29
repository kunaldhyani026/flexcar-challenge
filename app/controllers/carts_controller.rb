# frozen_string_literal: true

require 'ecommerce/cart_handler'

# Controller responsible for managing shopping cart actions.
class CartsController < ApplicationController
  before_action :validate_params, :fetch_item, except: :show

  def show
    render_response(Ecommerce::CartHandler.new(params[:user_id]).view_cart)
  end

  def add
    render_response(Ecommerce::CartHandler.new(params[:user_id]).add_item(@item, params[:quantity]))
  end

  def remove
    render_response(Ecommerce::CartHandler.new(params[:user_id]).remove_item(@item, params[:quantity]))
  end

  private

  # Validates input params for add and remove action, returns error to user for bad input
  def validate_params
    unless params[:quantity].present? && params[:quantity].instance_of?(Integer) && params[:quantity].positive?
      render_error('invalid_request_error', 'Quantity should be a positive integer', 400)
    end
  end

  # Finds the item from inventory before add or remove action, returns error to user if item doesn't exists
  def fetch_item
    @item = Item.find(params[:item_id])
  rescue ActiveRecord::RecordNotFound => e
    render_error('invalid_request_error', e.message, 404)
  end
end

