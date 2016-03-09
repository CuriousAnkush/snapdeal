module Api
  module V1
    class ProductsController < BaseController      
      # POST /products
      # POST /products.json
      def create
        response_hash = {message: 'Product has been created successfully', status: :created}
        Product.create_from_api(product_params.except(:controller, :action))
        respond(response_hash)
      end

      private
      # Never trust parameters from the scary internet, only allow the white list through.
      def product_params
        params.require(:product).permit!
      end
    end
  end
end


module ABC

  def xyx
    puts "this is a module instance method"
  end
end

class MNO
 
 def initialize(name)
   @name = name
 end

 def name= (name)
    @name = name
 end

 def name
  @name
 end

end