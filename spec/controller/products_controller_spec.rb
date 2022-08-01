require 'rails_helper'

RSpec.describe Product, :type => :request do
  15.times{
    FactoryBot.create(:product, currency: "USD")
  }

  it "Request without parameters" do
    post "/products", :params => { }

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(200)
  end

  it "Parameters at zero" do
    post "/products", :params => { :page => "0", :size => "0"}
    expected = (
      {
        "metadata": {
                      "page": 0, 
                      "total_records": 0 
                    },
        "products": []
      }
    )
    expect(response.body).to eql(expected.to_json)
    expect(JSON.parse(response.body)["products"].size).to eql(0)
  end

  it "Caudno there is no exchange rate in the base" do
    post "/products", :params => {:page => "1", :size => "10", currency: "CVE"}
    expect(JSON.parse(response.body)["products"].size).to eql(0)
  end

  it "Parameters filtered by size" do
    post "/products", :params => {:page => "1", :size => "2", :query => "", :currency => "USD" }

    expect(JSON.parse(response.body)["products"].size).to eql(2)
  end

  it "Test of the size limit, when it is exceeded it returns the minimum set" do
    post "/products", :params => {:page => "1", :size => "15"}

    expect(JSON.parse(response.body)["products"].size).to eql(10)
  end

  it "Name and currency are sent in the params" do
    FactoryBot.create(:product, name: "Test", currency: "CAD")
    post "/products", :params => {:page => "1", :size => "3", query: "Test", currency: "CAD" }

    expect(JSON.parse(response.body)["products"].size).to eql(1)
  end
end
