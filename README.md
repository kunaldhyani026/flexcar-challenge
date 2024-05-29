# Flexcar Challenge

## Problem Statement

[Flexcar Assignment - Description](https://docs.google.com/document/d/186j9G6UzVhUGaq-Ere20v9m8qVfzF4Wq/edit?usp=sharing&ouid=112122512048807392879&rtpof=true&sd=true)
## Running the Application
### Prerequisites
Make sure you have Docker installed on your system. You can download and install Docker from [here](https://www.docker.com/get-started).
### Setting up the Application / Deploy using docker images
- Pull the docker image:
  ```
  docker pull kunaldhyani026/flexcar-challenge-image
  ```
- Run the container:
  ```
  docker run -p 3000:3000 --name flexcar-challenge-container -d kunaldhyani026/flexcar-challenge-image
  ```
- APIs accessible at `http://localhost:3000/` [Use postman or cURL to hit JSON API requests]

  Example:
  ```
  curl --location 'http://localhost:3000/cart/add?user_id=12345' --header 'Content-Type: application/json' --data '{"item_id": 1,"quantity": 2}'
  ```

### Test Pipeline
- To run the specs:
  - Login to container: `docker exec -it flexcar-challenge-container bash`
  - Run: `rspec`
### APIs
- **Add Item to cart API**: ```POST /cart/add?user_id=1234```
  - Request body: 
    - ```item_id```: Integer
    - ```quantity```: Integer( > zero)

    Both the payload parameter and query_param ```user_id``` is required to fetch the response.

    Use any API testing tool (eg: Postman, cURL) to hit JSON API request.

    Example:
    ```
    curl --location 'http://localhost:3000/cart/add?user_id=1234' --header 'Content-Type: application/json' --data '{"item_id": 1,"quantity": 2}'
    ```
  - Response format
 
    Response is hash with a key ```cart```.
    **Cart** is an array of hashes (eg: [{}, {}]). Each hash represent a item in the cart with below properties:
    - **item_id**: Integer
    - **quantity**: Integer
    - **actual_cost**: Decimal String stating the actual_cost of this item for present quantity before discount
    - **discounted_cost**: Decimal String stating the cost of this item for present quantity after applying best active discount (best out of flat_fee, percentage, buy_get, weight_threshold )
    - **savings**: Decimal String stating the money saved on this cart item by discount.
    ```
    {"cart":[{"item_id":1,"quantity":2,"actual_cost":"1080.0","discounted_cost":"1026.0","savings":"54.0"}]}
    ```
    
- **Remove Item from cart API**: ```POST /cart/remove?user_id=1234```
  - Request body: 
    - ```item_id```: Integer
    - ```quantity```: Integer( > zero)

    Both the payload parameter and query_param ```user_id``` is required to fetch the response.

    Use any API testing tool (eg: Postman, cURL) to hit JSON API request.

    Example:
    ```
    curl --location 'http://localhost:3000/cart/remove?user_id=1234' --header 'Content-Type: application/json' --data '{"item_id": 1,"quantity": 1}'
    ```
  - Response format
 
    Response is hash with a key ```cart```.
    **Cart** is an array of hashes (eg: [{}, {}]). Array represents the cart and Each hash represent a item in the cart with below properties:
    - **item_id**: Integer
    - **quantity**: Integer
    - **actual_cost**: Decimal String stating the actual_cost of this item for present quantity before discount
    - **discounted_cost**: Decimal String stating the cost of this item for present quantity after applying best active discount (best out of flat_fee, percentage, buy_get, weight_threshold )
    - **savings**: Decimal String stating the money saved on this cart item by discount.
    ```
    {"cart":[{"item_id":1,"quantity":1,"actual_cost":"540.0","discounted_cost":"513.0","savings":"27.0"}]}
    ```

- **View Cart API**: ```GET /cart?user_id=1234```
  - Request body:
    
    Query_param ```user_id``` is required to fetch the response.

    Use any API testing tool (eg: Postman, cURL) to hit JSON API request.

    Example:
    ```
    curl --location 'http://localhost:3000/cart?user_id=1234'
    ```
  - Response format
    
    Response is hash with a key ```cart_cost``` and ```cart```.

    **cart_cost** is a hash with three attributes:
    -  **total_actual_cost**:  Decimal String stating the actual cost of all items in cart without discount.
    -  **total_discounted_cost**:  Decimal String stating the discounted cost of all items in cart with best applicable discounts.
    -  **total_savings**: Decimal String stating the total money saved on the cart by discounts.
  
    **cart** is an array of hashes (eg: [{}, {}]). Array represents the cart and Each hash represent a item in the cart with below properties:
    - **item_id**: Integer
    - **quantity**: Integer
    - **actual_cost**: Decimal String stating the actual_cost of this item for present quantity before discount
    - **discounted_cost**: Decimal String stating the cost of this item for present quantity after applying best active discount (best out of flat_fee, percentage, buy_get, weight_threshold )
    - **savings**: Decimal String stating the money saved on this cart item by discount.
    ```
    {"cart_cost":{"total_actual_cost":"540.0","total_discounted_cost":"513.0","total_savings":"27.0"},
    "cart"[{"item_id":1,"quantity":1,"actual_cost":"540.0","discounted_cost":"513.0","savings":"27.0"}]}
    ```

### Observations, Assumptions and Points
- **user_id** is mandatory in query_params for any API to work, else unauthorized_user error is received.
- For simplicity, currently only check is to see if user_id is present in payload/headers or not. In production systems, user_id should be decoded from the auth token and
  then this user_id should be used ahead for maintaining user's cart states.
- We have used Rails memory_store cache, to keep the state of the cart per user_id. In production systems, some persistent memory store with time to live can be used.
- As requested, we have exposed three APIs for cart actions - add, remove, view. We have also written skeleton code (design, classes, modules, controllers & routes) for promotions action and inventory action, i.e., items - add, update, etc | promotions - add, update etc. due to timelines of 48 hours.
- The skeleton code is can be completed to make items inventory APIs and promotion APIs up and running.
- We have **validate_params** method which validates the input  pyaoad params first before proceeding further.
- Seed data for development is populated via db/seeds.rb
- Test data for specs are populated in each spec file.
- Test data can be optimized using **build_stubbed** instead of **create** method of FactoryBot.
- Invalid inputs, failures are handled and appropriate error responses is given to user with error message.
- **cart_handler.rb** handles cart actions.
- **promotion_handler.rb** handles promotion actions (finding best promotion etc). Skeleton code here can be completed to enable create_promotion, update_promotion functionalities.
- We have separate concrete classes for types of promotions all of them adhering to the common interface of **abstract_promotion.rb**

### Sample handled error responses
```
**Invalid User**
{
    "error": {
        "type": "unauthorized_user",
        "message": "invalid user_id"
    }
}
```
```
**Invalid item**
{
    "error": {
        "type": "invalid_request_error",
        "message": "Couldn't find Item with 'id'=156"
    }
}
```
```
**Trying to remove an item's quantity which is not present in cart**
{
    "error": "Body Moisturiser with 1 quantity not present in cart"
}
```

### Testing
Tests are written in `/spec/requests/carts/` directory. 26 tests covers scenarios like valid payload, invalid payload, add item to cart, remove item from cart, add already exisitng item, remove non-existing item from cart, failure handling and error response etc.

To run the specs -
- Login to application's docker container
- Run `rspec`
