require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end
  
  test "product price must be positive" do
    product = Product.new(:title => "title",
                          :description => "description here",
                          :image_url => "asda.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "Must be greater or equal to 0.01",
      product.errors[:price].join('; ')
      
    product.price = 0
    assert product.invalid?
    assert_equal "Must be greater or equal to 0.01",
      product.errors[:price].join('; ')
    
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(:title => "some title",
                :description => "some desctription",
                :image_url => image_url,
                :price => 10)
  end
  
  test "Image URL must be correct" do
    ok = %w{fred.gif fred.png trula.jpg MYRKA.gif http://myrka.com/image/buuu.jpg}
    bad = %w{asdm.dsf lolka.jpeg some.doc}
    
    ok.each do |url|
      assert new_product(url).valid?, "#{url} should not be invalid"
    end
    
    bad.each do |url|
      assert new_product(url).invalid?, "#{url} should not be valid"
    end
  end
  
  test "product is not valid withour a unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "some description",
                          :image_url => products(:ruby).image_url,
                          :price => 2)
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end
  
  test "product title must be min 10 characters" do
    product = Product.new(:description => "some description",
                :image_url => "asd.jpg",
                :price => 14)
    product.title = "short"
    assert product.invalid?
    assert_equal "Must be longer or equal to 10 characters",
      product.errors[:title].join('; ')
      
    product.title = "Someverylongtitle"
    assert product.valid?
  end
end
