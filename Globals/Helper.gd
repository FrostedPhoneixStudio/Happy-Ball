extends Node

# picks a random entry from a weighted list
# weighted_list must be a dictionary looking like this:
# {value to be picked : weight}
# where weight is an int
static func pick_random_from_weighted_list(weighted_list):
	var total_weight = 0
	
	var keys = weighted_list.keys()
		
	for key in keys:
		total_weight += weighted_list[key]

	var selected_key
		
	var random_number = randi_range(0, total_weight)

	var cumulative_weight = 0
	for key in keys:
		var weight = weighted_list[key]
		cumulative_weight += weight
		if random_number < cumulative_weight:
			return key

	return keys[0]
