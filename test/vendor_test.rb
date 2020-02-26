require 'minitest/autorun'
require 'minitest/pride'
require './lib/vendor'
require './lib/item'

class VendorTest < Minitest::Test

  def setup
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

  end

  def test_it_exists
    assert_instance_of Vendor, @vendor1
  end

  def test_it_has_attributes
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_equal "Rocky Mountain Fresh",  vendor.name
    assert_equal ({}), vendor.inventory
  end

  def test_it_checks_stock
    assert_equal 0, @vendor1.check_stock(@item_1)
  end

  def test_it_stocks_items
    @vendor1.stock(@item1, 30)
    expected1 = {@item1 => 30}

    assert_equal expected1, @vendor1.inventory


    @vendor1.stock(@item1, 25)
    expected2 = {@item1 => 55}

    assert_equal expected2, @vendor1.inventory

    @vendor1.stock(@item2, 12)
    expected3 = {@item1 => 55, @item2 => 12}

    assert_equal expected3, @vendor1.inventory
  end

  def test_it_calculates_potential_revenue
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)

    assert_equal 29.75, @vendor1.potential_revenue
    assert_equal 345.00, @vendor2.potential_revenue
    assert_equal 48.75, @vendor3.potential_revenue
  end


end
