class Product < ActiveRecord::Base
  serialize :product_category_ids
  serialize :tag_ids
  serialize :vars
  validates :name, presence: true
  has_many :prodcut_categories
  has_many :tags
  has_many :images, class_name: 'ProductImage'

  def self.create_from_api(attributes)
    Product.transaction do 
      product = Product.new(attributes.except(:tags, :categories, :images, :expire_date))
      product.expire_date = Date.parse(attributes[:expire_date])
      product.product_category_ids = ProdcutCategory.where(name: attributes[:categories]).map(&:id)
      product.tag_ids = Tag.where(id: attributes[:tags]).map(&:id)
      product_images = []
      product.save!
      if attributes[:images].present?
        attributes[:images].each do |image_attributes|
          product_images << ProductImage.create!(image_attributes.merge!(product_id: product.id))
        end
      end
    end   
  end
end
