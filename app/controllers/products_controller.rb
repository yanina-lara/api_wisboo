class ProductsController < ApplicationController

  MIN_PAGINATION_LIMIT = 10
  DEFAULT_CURRENCY = "USD".freeze

  def index
    @products = Product.filter_currency(currency).filter_query(query_name).page(page).per(limit)
    render json: response_products.as_json
  end

  private
  
  def limit
    [
      products_params["size"].to_i, 
      MIN_PAGINATION_LIMIT
    ].min
  end

  def page
    products_params["page"].to_i
  end

  def currency
    return DEFAULT_CURRENCY if products_params["currency"].blank?
    products_params["currency"]
  end

  def query_name
    products_params["query"]
  end
  
  def products_params
    params.permit(:page, :size, :query, :currency)
  end

  def response_products
    {"metadata": 
      {
        "page": page,
        "total_records": @products.size
      },
      "products": @products
    }
  end
end
