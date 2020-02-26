class Market

  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name = name
    @vendors = []
    @date ||= Date.today.strftime("%m/%d/%Y")
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

  def find_unique_inventory
    @vendors.flat_map { |vendor| vendor.inventory.keys }.uniq
  end

  def total_inventory
    find_unique_inventory.reduce ({}) do |inv_list, item|
      inv_list[item] = {
        quantity: @vendors.sum { |vendor| vendor.inventory[item]},
        vendors: @vendors.select { |vendor| vendor.inventory.include? item}
      }
      inv_list
    end
  end

  def overstocked_inventory
    total_inventory.select do |item, data|
      data[:quantity] > 50 && data[:vendors].size > 1
    end
  end

  def overstocked_items
    overstocked_inventory.map { |item, data| item }
  end

  def sorted_item_list
    total_inventory.map { |item, data| item.name }.sort
  end

  def sell(item, quantity)
    return false if total_inventory[item][:quantity] < quantity
    while quantity > 0
      total_inventory[item][:vendors].each do |vendor|
        if vendor.inventory[item] <= quantity
          quantity = quantity - vendor.inventory[item]
          vendor.inventory[item] = 0
        else
          vendor.inventory[item] = vendor.inventory[item] - quantity
          quantity = 0
        end
      end
    end
    true
  end
end
