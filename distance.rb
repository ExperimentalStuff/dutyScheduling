class Duty
	attr_accessor :input, :appointment, :duty_days, :available, :to_add_back, :combinations, :weighted_score, :max_score, :max_index, :selected_combination, :residual_available
	# define: available = "previously available days for arranging"
	def initialize(input, appointment, duty_days)
		@input = input
		@appointment = appointment
		@duty_days = duty_days
		# other constants get from input
		@available = available_days(@input, @appointment)
		# set a new variable is_valid to check if more available days than duty days to be arranged
		# proceed only if valid, use flag to show invalid, and not push into results if invalid
		@to_add_back = add_back_days(@input, @appointment)
		@combinations = get_conbinatoric(@available, @duty_days)
		@weighted_score = get_weighted_score(@combinations)
		@max_score = @weighted_score.max
		# if max_score = 0 means all results are having QD duty. stop and raise invalid flag
		@max_index = get_max_index(@weighted_score, @max_score)
		@selected_combination = select_combination(@combinations, @max_index)
		@residual_available = get_residual_available(@input, @selected_combination, @to_add_back)
	end

	# pre-processing available days: remove appointment of no duty-days from previous results of days
	# return array for processing
	def available_days(available, appointment)
		available.reject{|x| appointment.find_index(x)}
	end

	#@available = available_days(@input, @appointment)

	# get appointment days that are available before process
	# add back these days after total process for next person to run algorithm
	def add_back_days(available, appointment)
		available.select{|x| appointment.find_index(x)}
	end

	#@to_add_back = add_back_days(@input, @appointment)


	# precheck: if available days less than duty_days: stop processing and return to previous person
	def days_enough?(available, duty_days)
		available.length < duty_days
	end

	# intake an array, sort it and return difference of adjacent elements
	def diff(ary)

		if ary.length<2 
			return nil
		end

		ary = ary.sort
		result = []
		for  i in 0..(ary.length-2)
			result.push(ary[i+1]-ary[i])
		end
		result
	end

	# intake and array and return multiplication of all items
	def chain_multiply(ary)
		ary.inject(1) do |total, item|
			total = total * item
			total
		end
	end

	# duty_days : number of days selected from base

	# return array of arrays selecting x numbers of elements from input array
	# ary.sort!.uniq!.combination(duty_days).to_a
	def get_conbinatoric(available, duty_days)
		available.combination(duty_days).to_a
	end

	###@combinations = get_conbinatoric(@available, @duty_days)

	# return array of distant between adjacent elements
	# ary.sort!.uniq!.combination(duty_days).to_a.map{|x| diff(x)}
	def get_weighted_score(combination)
		combination.map{|x| diff(x)}.map{|x| chain_multiply(x)}
	end

	# return array of weighted (multiplication of distance) distance 
	# ary.sort!.uniq!.combination(duty_days).to_a.map{|x| diff(x)}.map{|x| chain_multiply(x)}
	###@weighted_score = get_weighted_score(@combinations)

	# return max of weighted score
	# max_score = ary.sort!.uniq!.combination(duty_days).to_a.map{|x| diff(x)}.map{|x| chain_multiply(x)}.max
	###@max_score = @weighted_score.max

	# select indexes of item with max weighted score
	# weighted_score = ary.sort!.uniq!.combination(duty_days).to_a.map{|x| diff(x)}.map{|x| chain_multiply(x)}
	def get_max_index(weighted_score, max_score)
		weighted_score.each_index.select{|x| weighted_score[x]==max_score}
	end
	# max_index = weighted_score.each_index.select{|x| weighted_score[x]==max_score}
	###@max_index = get_max_index(@weighted_score, @max_score)
	# return array of combinations with max weighted score
	# selected_combination = max_index.map{|x| ary.sort!.uniq!.combination(duty_days).to_a[x]}
	def select_combination(combination, max_index)
		max_index.map{|x| combination[x]}
	end

	###@selected_combination = selected_combination(@combinations, @max_index)

	# add back previously appointment non-duty day to residual days
	def get_residual_available(input, selected_combination, to_add_back)
		new_array = selected_combination.map{|x| input.reject{|y| x.find_index(y)}}
		new_array.map{|x| x.concat(to_add_back).sort!}
	end

	###@residual_available = get_residual_available(@selected_combination, @to_add_back)
end
	# these arrays then deducted from available days
	# new_array = input_array.reject{|x| selected_array.find_index(x)}

	# before action: remove appointted no-duty day from total available days