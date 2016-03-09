json.array!(@products) do |product|
  json.extract! product, :id, :name, :collection_id, :sku_id, :vars, :price, :description, :expire_date
  json.url product_url(product, format: :json)
end
