local filters = {}

filters["personal-filter-mk1"] = --TODO: use constants for the name
{
	width = 1, height = 1, input = "10KW", buffer = "10KJ",
	ingredients = {
		{"copper-plate", 10}
	},
	expensive_ingredients = {
		{"copper-plate", 10}
	}
}

filters["personal-filter-mk2"] = 
{
	width = 1, height = 1, input = "100KW", buffer = "100KJ",
	ingredients = {
		{"steel-plate", 10}
	},
	expensive_ingredients = {
		{"copper-plate", 10}
	},
}

filters["personal-filter-mk3"] = 
{
	width = 1, height = 1, input = "250KW", buffer = "250KJ",
	ingredients = {
		{"low-density-structure", 10}
	},
	expensive_ingredients = {
		{"copper-plate", 10}
	},
}

filters["personal-filter-mk4"] = 
{
	width = 1, height = 1, input = "500KW", buffer = "500KJ",
	ingredients = {
		{"used-up-uranium-fuel-cell", 10}
	},
	expensive_ingredients = {
		{"copper-plate", 10}
	},
}

for name, filter in pairs(filters) do

	local filter_equipment = table.deepcopy(data.raw["battery-equipment"]["battery-equipment"])
	filter_equipment.name = name
	filter_equipment.energy_input = filter.power

	filter_equipment.shape = { width = filter.width, height = filter.height, type = "full" }
	--filter_equipment.categories = {"personal-filter"}
	filter_equipment.energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		input_flow_limit = filter.input,
		output_flow_limit = "0W",
		buffer_capacity = filter.buffer,
	}
	filter_equipment.sprite = {
		filename = "__EMC__/graphics/filters/" .. name .. ".png",
		size = 64
	}
  
	local filter_item = table.deepcopy(data.raw["item"]["battery-equipment"])
	filter_item.name = name
	filter_item.placed_as_equipment_result = name
	filter_item.subgroup = "equipment"
	filter_item.order = name
	filter_item.icon = "__EMC__/graphics/filters/" .. name .. ".png"
	filter_item.icon_size = 64
	filter_item.icon_mipmaps = 1
  
	local filter_recipe = table.deepcopy(data.raw["recipe"]["battery-equipment"])
	filter_recipe.name = name
	filter_recipe.enabled = true
	filter_recipe.result = name
	filter_recipe.ingredients = filter.ingredients
	filter_recipe.energy = 5
	filter_recipe.subgroup = "equipment"
  
	data:extend({
	filter_equipment,
	filter_item,
	filter_recipe,
	})
  
  end
  
--   data:extend ({ //TODO: Add this to the equipment list
-- 	{
-- 	  name = "personal-filter",
-- 	  type = "equipment-category",
-- 	},
--   })