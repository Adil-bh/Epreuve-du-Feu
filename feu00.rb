#Partie 1 : Parsing
length = ARGV[0].to_i
width = ARGV[1].to_i

#Fonction utilisées
def rectangle_display(length, width)
	string_rectangle = ""
	line_length = ""
	line_width = ""

	#Création de la ligne de longueur
	line_length = "-" * length
	line_length[0], line_length[-1] = "o", "o"	#o----o

	#Création de la ligne de largeur
	if width > 1 && length == 1       					#Si longueur = 1 ; Largeur = |
		line_width += "|" * (width - 1)
		line_width[-1] = "o"
	elsif width > 2
		line_width += "|" + " " * (length - 2) + "|\n"  #Si longueur > 1 ; Largeur = |    |
		line_width *= width - 2
	end

	string_rectangle = line_length + (width > 1 ? "\n" + line_width + line_length : "") #Si width = 1 on ne print que la longueur
	return string_rectangle
end

#Partie 2 : Gestion d'erreur
if length <= 0 || width <= 0
	puts "error : Invalid Dimensions"
	exit
end

#Partie 3 : Résolution
result = rectangle_display(length, width)

#Partie 4 : Affichage
print result