#C'était trop dur
#Mise au format String => Array de l'expression
#Formatage des nombres et opérateurs
#Utilisation de l'algorithme de Shunting Yard pour résolution

#Partie 1 : Parsing
arithmetic_expression = ARGV[0]

#Fonction utilisées
def stringExpression_to_arrayExpression(string)
	array = string.split('')
	array.delete(' ')
	result_array = []
	current_number = ""

	for i in 0..array.length - 1
		if array[i].match(/[0-9]/)
			current_number += array[i]
		else
			result_array << current_number unless current_number.empty?
			result_array << array[i]
			current_number = ""
		end
	end
	result_array << current_number unless current_number.empty?
	return result_array
end

def set_types_to_array_values(array)
	operators = ["+", "-", "*", "/", "%"]
	output_array = []

	array.each do |element|
		if element.match(/[0-9]/)
			output_array << element.to_i
		elsif element.match(/[+\-*\/%]/)
			output_array << element.to_sym
		else
			output_array << element
		end
	end
	return output_array
end

def processValue(value, postfix_expression, stack, operator_priority)
	if value.is_a?(Integer)
		postfix_expression << value
	elsif value.is_a?(Symbol)
		while !stack.empty? && stack[-1].is_a?(Symbol) && operator_priority[stack[-1]] >= operator_priority[value]
			top_operator = stack.pop
			postfix_expression << top_operator
		end
		stack << value
	elsif value == "("
		stack << value
	elsif value == ")"
		while !stack.empty? && stack[-1] != "("
			top_operator = stack.pop
			postfix_expression << top_operator
		end
		stack.pop
	end
end

###### Conversion en notation postfixée ######
def to_postfix_expression(infix_expression)
	postfix_expression = []
	stack = []
	operator_priority = {
	  :+ => 1,
	  :- => 1,
	  :* => 2,
	  :/ => 2,
	}

	infix_expression.each do |value|
		processValue(value, postfix_expression, stack, operator_priority)
	end
	while !stack.empty?
		top_operator = stack.pop
		postfix_expression << top_operator
	end
	return postfix_expression
end

###### Evaluation de la notation postfixée ######
def get_result_from_postfix(postfix_expression)
	stack_of_numbers = []

	postfix_expression.each do |value|
		if value.is_a?(Integer)
			stack_of_numbers << value
		else
			# puts value
			number2 = stack_of_numbers.pop
			number1 = stack_of_numbers.pop
			result = number1.send value, number2
			# puts "number 1 : #{number1} operator : #{value}  number2 : #{number2}"
			# puts "result : #{result}"
			stack_of_numbers << result
		end
	end
	return stack_of_numbers
end

#Partie 2 : Résolution
array_of_expression = stringExpression_to_arrayExpression(arithmetic_expression)
array_of_expression = set_types_to_array_values(array_of_expression)
result = to_postfix_expression(array_of_expression)

#Partie 3 : Affichage
puts get_result_from_postfix(result)