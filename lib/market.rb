class Market

  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.select { |vendor| vendor.inventory[item] > 0 }
  end

  def total_inventory
    inventory_sold = @vendors.flat_map do |vendor|
      vendor.inventory.keys
    end.uniq
    inventory_sold.reduce ({}) do |inv_list, item|
      inv_list[item] = {
        quantity: @vendors.sum { |vendor| vendor.inventory[item]},
        vendors: @vendors.select { |vendor| vendor.inventory.include? item}
      }
      inv_list
    end
  end

  def overstocked_items
    over_items = total_inventory.select do |item, data|
      data[:quantity] > 50 && data[:vendors].size > 1
    end
    over_items.map do |item, data|
      item
    end
  end

  def sorted_item_list
    total_inventory.map { |item, data| item.name }.sort
  end
end
