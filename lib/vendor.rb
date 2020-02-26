class Vendor

  attr_reader :name
  attr_accessor :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, amount)
    @inventory[item] += amount
  end

  def potential_revenue
    @inventory.sum do |item, amount|
      item.price.gsub("$", "").to_f * amount
    end
  end

end
