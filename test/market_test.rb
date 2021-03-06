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
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
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

  def test_it_finds_unique_inventory
    expected = [@item1, @item2, @item4, @item3]
    assert_equal expected, @market.find_unique_inventory
  end

  def test_it_finds_total_inventory
    expected = {
      @item1 => {
        quantity: 100, vendors: [@vendor1, @vendor3]
      },
      @item2 => {
        quantity: 7, vendors: [@vendor1]
      },
      @item3 => {
        quantity: 35, vendors: [@vendor2, @vendor3]
      },
      @item4 => {
        quantity: 50, vendors: [@vendor2]
      }
    }

    assert_equal expected, @market.total_inventory
  end

  def test_it_finds_overstocked_inventory
    expected = {
      @item1 => {
        quantity: 100, vendors: [@vendor1, @vendor3]
      }
    }

    assert_equal expected, @market.overstocked_inventory
  end

  def test_it_indentifies_overstocked_items
    assert_equal [@item1], @market.overstocked_items
  end

  def test_it_returns_sorted_item_list
    expected = ["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"]

    assert_equal expected, @market.sorted_item_list
  end

  def test_it_has_a_date
    assert_equal "02/26/2020", @market.date

    now = Date.today
    not_now = now - 14
    Date.stubs(:today).returns(not_now)
    new_market = Market.new("Cherry Creek Farmer's Market")

    assert_equal "02/12/2020", new_market.date

    future_now = now + 1
    Date.stubs(:today).returns(future_now)
    new_market2 = Market.new("Madison Farmer's Market")
    assert_equal "02/27/2020", new_market2.date
  end

  def test_it_sells_items
    assert_equal 35, @vendor1.check_stock(@item1)
    assert_equal 65, @vendor3.check_stock(@item1)
    assert @market.sell(@item1, 40)
    assert_equal 0, @vendor1.check_stock(@item1)
    assert_equal 60, @vendor3.check_stock(@item1)

    assert_equal false, @market.sell(@item2, 80220)
  end

end
