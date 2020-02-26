require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'
require './lib/item'
require './lib/market'
require 'mocha/minitest'

class MarketTest < Minitest::Test
  def setup
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_it_has_attributes
    my_market = Market.new("South Pearl Street Farmers Market")

    assert_equal "South Pearl Street Farmers Market", my_market.name
    assert_equal [], my_market.vendors
  end

  def test_it_adds_vendors

    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
  end

  def test_it_returns_vendor_names
    assert_equal [@vendor1.name, @vendor2.name, @vendor3.name], @market.vendor_names
  end

  def test_it_finds_vendors_who_sell_an_item
    item5 = mock("Rhubarb")
    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)
    assert_equal [@vendor2], @market.vendors_that_sell(@item4)
    assert_equal [], @market.vendors_that_sell(item5)
  end
end
