require 'rails_helper'

RSpec.describe 'Add Item to Cart API', type: :request do
  describe 'POST /cart/add' do
    before do
      # creating categories
      category_footwear = create(:category, name: 'Footwear', id: 1)
      category_electronics = create(:category, name: 'Electronics', id: 2)
      category_skincare = create(:category, name: 'Skincare', id: 3)

      # creating brands
      brand_nike = create(:brand, name: 'Nike', id: 1)
      brand_puma = create(:brand, name: 'Puma', id: 2)
      brand_samsung = create(:brand, name: 'Samsung', id: 3)
      brand_apple = create(:brand, name: 'Apple', id: 4)
      brand_lakme = create(:brand, name: 'Lakme', id: 5)
      brand_cetaphil = create(:brand, name: 'Cetaphil', id: 6)

      # creating items
      create(:item, name: 'Bathroom Slipper', price: 540.0, stock_balance: 4, brand: brand_nike,
             category: category_footwear, id: 1)
      create(:item, name: 'Sports Shoes', price: 1200.0, stock_balance: 2, brand: brand_nike,
             category: category_footwear, id: 2)
      create(:item, name: 'Room Slipper', price: 800.0, stock_balance: 5, brand: brand_puma,
             category: category_footwear, id: 3)
      create(:item, name: 'RXS Sneaker', price: 6500.0, stock_balance: 2, brand: brand_puma,
             category: category_footwear, id: 4)
      create(:item, name: 'Smartphone', price: 15_000.0, stock_balance: 10, brand: brand_samsung,
             category: category_electronics, id: 5)
      item_smartwatch = create(:item, name: 'Smartwatch', price: 6000.0, stock_balance: 1, brand: brand_samsung,
                               category: category_electronics, id: 6)
      create(:item, name: 'Front Load Washing Machine', price: 16_500.0, stock_balance: 1, brand: brand_samsung,
             category: category_electronics, id: 7)
      create(:item, name: 'iPhone 14', price: 80_000.0, stock_balance: 5, brand_id: brand_apple.id,
             category: category_electronics, id: 8)
      item_cleanser = create(:item, name: 'Face Cleanser', price: 400.0, stock_balance: 2, brand: brand_cetaphil,
                             category: category_skincare, id: 9)
      item_moisturiser = create(:item, name: 'Body Moisturiser', price: 500.0, stock_balance: 6, brand: brand_cetaphil,
                                category: category_skincare, id: 10)
      item_perfume = create(:item, name: 'Perfume', price: 600.0, stock_balance: 1, brand: brand_cetaphil,
                            category: category_skincare, id: 11)
      item_color_palette = create(:item, name: 'Color Palette', price: 2000.0, stock_balance: 2, brand: brand_lakme,
                                  category: category_skincare, id: 12)
      item_banana_chips = create(:item, name: 'Banana Chips', price: 10.0, selling_unit: :weight, stock_balance: 1200, id: 13)
      create(:item, name: 'Mango Candy', price: 20.0, selling_unit: :weight, stock_balance: 1000, id: 14)

      # Creating Promotion Types
      flat_fee_promo = create(:promotion, name: 'Flat Fee Discount', id: 1,
                              description: 'This promotion offers flat fee discount (ex: 20 dollars off on an item)')
      percent_promo = create(:promotion, name: 'Percentage Discount', id: 2,
                             description: 'This promotion offers Percentage discount (ex: 10% of off an item)')
      buy_get_promo = create(:promotion, name: 'Buy X Get Y Discount', id: 3,
                             description: 'This promotion offers Buy X Get Y discount(ex:Buy 1 get one free, buy 3 get 1 50% off)')
      weight_threshold_promo = create(:promotion, name: 'Weight Threshold Discount', id: 4,
                                      description: 'This promotion offers Weight threshold discounts
                                (ex: buy more than 100 grams and get 50% off the item)')

      # Concrete Table inheritance database design
      # Creating discounts on items and categories in their respective discount_promotions table
      create(
        :flat_fee_discount_promotion,
        promotion: flat_fee_promo,
        discount_amount: 100.0,
        start_time: Time.now,
        end_time: Time.now + 10.days,
        item: item_moisturiser,
        id: 1
      )

      create(
        :flat_fee_discount_promotion,
        promotion: flat_fee_promo,
        discount_amount: 50.0,
        start_time: Time.now,
        end_time: Time.now + 10.days,
        item: item_smartwatch,
        id: 2
      )

      create(
        :percentage_discount_promotion,
        promotion: percent_promo,
        discount_percentage: 5,
        start_time: Time.now,
        end_time: Time.now + 30.days,
        category: category_footwear,
        id: 1
      )

      create(
        :buy_get_discount_promotion,
        promotion: buy_get_promo,
        buy_quantity: 1,
        get_quantity: 1,
        start_time: Time.now,
        end_time: Time.now + 24.hours,
        item: item_color_palette,
        id: 1
      )

      create(
        :buy_get_discount_promotion,
        promotion: buy_get_promo,
        buy_quantity: 3,
        get_quantity: 1,
        start_time: Time.now + 48.hours,
        item: item_perfume,
        id: 2
      )

      create(
        :weight_threshold_discount_promotion,
        promotion: weight_threshold_promo,
        weight_threshold: 1000,
        discount_percentage: 20,
        start_time: Time.now,
        end_time: Time.now + 24.hours,
        item: item_banana_chips,
        id: 1
      )
    end

    context 'when params are not valid' do
      it 'returns a 401 unauthorized response when user_id is not present' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => 1 }
        post '/cart/add', params: payload.to_json, headers: headers

        # asserting that response status is 401
        expect(response.status).to eq(401)

        # asserting that response body have error details
        body = response_body
        expect(body).to eq({
                             'error' => {
                               'type' => 'unauthorized_user',
                               'message' => 'invalid user_id'
                             }
                           })
      end

      it 'returns a not found response when item_id is not found' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 25, 'quantity' => 1 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 404
        expect(response.status).to eq(404)

        # asserting that response body have error details
        body = response_body
        expect(body).to eq({
                             'error' => {
                               'type' => 'invalid_request_error',
                               'message' => "Couldn't find Item with 'id'=25"
                             }
                           })
      end

      it 'returns a bad request response when quantity is decimal' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => 1.25 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 400
        expect(response.status).to eq(400)

        # asserting that response body have error details
        body = response_body
        expect(body).to eq({
                             'error' => {
                               'type' => 'invalid_request_error',
                               'message' => 'Quantity should be a positive integer'
                             }
                           })
      end

      it 'returns a bad request response when quantity is string' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => '2' }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 400
        expect(response.status).to eq(400)

        # asserting that response body have error details
        body = response_body
        expect(body).to eq({
                             'error' => {
                               'type' => 'invalid_request_error',
                               'message' => 'Quantity should be a positive integer'
                             }
                           })
      end

      it 'returns a bad request response when quantity is negative' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => -2 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 400
        expect(response.status).to eq(400)

        # asserting that response body have error details
        body = response_body
        expect(body).to eq({
                             'error' => {
                               'type' => 'invalid_request_error',
                               'message' => 'Quantity should be a positive integer'
                             }
                           })
      end

      it 'returns a bad request response when quantity is zero' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => 0 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 400
        expect(response.status).to eq(400)

        # asserting that response body have error details
        body = response_body
        expect(body).to eq({
                             'error' => {
                               'type' => 'invalid_request_error',
                               'message' => 'Quantity should be a positive integer'
                             }
                           })
      end
    end

    context 'when params are valid' do
      it 'adds item to cart for the specified user_id, applies promotion and shows discount' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => 2 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is correct
        body = response_body
        expect(body).to eq({
                             'cart' => [{
                                          'item_id' => 1, 'quantity' => 2,
                                          'savings' => '54.0',
                                          'actual_cost' => '1080.0',
                                          'discounted_cost' => '1026.0'
                                        }]
                           })
      end

      it 'updates the quantity if cart already have the item, applies promotion and shows discount ' do
        allow_any_instance_of(Ecommerce::CartHandler).to receive(:user_cart).and_return([{
                                                                                           item_id: 1, quantity: 2,
                                                                                           savings: 54.0,
                                                                                           actual_cost: 1080.0,
                                                                                           discounted_cost: 1026.0
                                                                                         }])
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 1, 'quantity' => 5 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is as expected
        body = response_body
        expect(body).to eq({
                             'cart' => [{
                                          'actual_cost' => '3780.0',
                                          'discounted_cost' => '3591.0',
                                          'savings' => '189.0',
                                          'item_id' => 1, 'quantity' => 7
                                        }]
                           })
      end

      it 'adds new item to cart along with other existing items, applies promotion and shows discount ' do
        allow_any_instance_of(Ecommerce::CartHandler).to receive(:user_cart).and_return([{
                                                                                           item_id: 1, quantity: 7,
                                                                                           savings: 189.0,
                                                                                           actual_cost: 3780.0,
                                                                                           discounted_cost: 3591.0
                                                                                         }])
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 2, 'quantity' => 4 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is as expected
        body = response_body
        expect(body).to eq({
                             'cart' => [{
                                          'actual_cost' => '3780.0',
                                          'discounted_cost' => '3591.0',
                                          'savings' => '189.0',
                                          'item_id' => 1, 'quantity' => 7
                                        },
                                        {
                                          'actual_cost' => '4800.0',
                                          'discounted_cost' => '4560.0',
                                          'savings' => '240.0',
                                          'item_id' => 2, 'quantity' => 4
                                        }]
                           })
      end
    end

    context "Various Promotion Discounts Applied" do
      it 'adds new item to cart, applies promotion flat_fee (100 off) and shows discount ' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 10, 'quantity' => 2 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is as expected
        body = response_body
        expect(body).to eq({
                             'cart' => [{ 'actual_cost' => '1000.0',
                                          'discounted_cost' => '800.0',
                                          'savings' => '200.0',
                                          'item_id' => 10, 'quantity' => 2
                                        }]
                           })
      end

      it 'adds new item to cart, applies percentage promotion (5% off) and shows discount ' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 4, 'quantity' => 1 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is as expected
        body = response_body
        expect(body).to eq({
                             'cart' => [{ 'actual_cost' => '6500.0',
                                          'discounted_cost' => '6175.0',
                                          'savings' => '325.0',
                                          'item_id' => 4, 'quantity' => 1
                                        }]
                           })
      end

      it 'adds new item to cart, applies buy_get promotion (buy 1 get 1) and shows discount ' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 12, 'quantity' => 2 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is as expected
        body = response_body
        expect(body).to eq({
                             'cart' => [{ 'actual_cost' => '4000.0',
                                          'discounted_cost' => '2000.0',
                                          'savings' => '2000.0',
                                          'item_id' => 12, 'quantity' => 2
                                        }]
                           })
      end

      it 'adds new item to cart, applies weight_threshold promotion (buy 1000 gm or more weight and get 20% off) and shows discount ' do
        # Trigger API call
        headers = { 'Content-Type' => 'application/json' }
        payload = { 'item_id' => 13, 'quantity' => 1150 }
        post '/cart/add?user_id=1234', params: payload.to_json, headers: headers

        # asserting that response status is 200
        expect(response.status).to eq(200)

        # asserting that response body is as expected
        body = response_body
        expect(body).to eq({
                             'cart' => [{ 'actual_cost' => '11500.0',
                                          'discounted_cost' => '9200.0',
                                          'savings' => '2300.0',
                                          'item_id' => 13, 'quantity' => 1150
                                        }]
                           })
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end



