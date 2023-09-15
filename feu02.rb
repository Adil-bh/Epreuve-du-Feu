=begin
*On lit les fichiers donnés en arguemnts : le board et to_find
*On transforme le contenu string du fichier en une matrice
*On parcours chaque caractère de la matrice
*Si le caractère parcouru == premier caractère de la matrice to_find (calque) alors à partir de cet index on va créer une sous matrice de la même
taille que le calque pour faire une comparaison
  *Si sous matrice == calque alors les index i et j sont les coordonnées de la forme sinon passer à l'index suivant de la matrice board
  *Si sous matrice == calque on créé une nouvelle matrice résultat à partir des dimensions de la matrice board qui ne contient que des "-".
  *On va parcourir cette nouvelle matrice jusqu'à arriver aux coordonnées où débute la forme, pour remplacer les valeurs de la matrice résultat par 
  les valeurs du calque
  *Mettre la matrice résultat au format texte
  *Afficher trouvé + coordonnées + matrice résultat
*Si aucune valeur == première valeure calque ou aucune sous matrice == calque afficher
Introuvable
=end

require 'matrix'

#Partie 1 : Parsing
main_matrix = ARGV[0]
calk_matrix = ARGV[1]

#Fonction utilisées
def from_text_to_matrix(filename)
  matrix = []
  filename = File.open("#{filename}", "r")
  filename.each_line do |line|
    line = line.split('')
    line.pop #Pour supprimer le "\n" de la ligne
    matrix << line
    end
  filename.close
  return matrix
end

def from_matrix_to_text(matrix)
  result = ""
  for i in 0..matrix.length - 1
    result += matrix[i].join('') + "\n"
  end 
  return result
end

def find_form(submatrix, calk) #Méthode qui permet de comparer la sous matrice au calque
  n = submatrix[0].length - 1
  m = submatrix.length - 1
  for i in 0..n
    for j in 0..m
      if calk[i][j] == " "
        submatrix[i][j] = " "
      end
    end
  end
  return true if submatrix == calk 
end

def create_submatrix_to_calk_dimensions(matrix, x, y, calk) #Méthode qui permet de créer une sous matrice aux dimensions du calque
  array_of_test = []

  for i in 0...calk.length
    row = []
    for j in 0...calk[0].length
      if (x + i < matrix.length) && (y + j < matrix[0].length)
        row << matrix[x + i][y + j]
      else
        # Gérer les cas où les indices sortent des limites de la matrice
        return nil  # Retourne nil si une valeur nulle est rencontrée
      end
    end
    array_of_test << row
  end
  return find_form(array_of_test, calk)
end

def is_form_first_value?(value, calk)
  return true if value == calk[0][0]
end

def final_matrix_display(matrix, calk, coordinates)
  final_board = Array.new(matrix.length) { Array.new(matrix[0].length, "-") }
  final_board_rows = final_board.length - 1
  final_board_columns = final_board[0].length - 1

  #On parcours la matrice jusqu'à arriver aux coordonnées de la forme
  for i in 0..final_board_rows
    for j in 0..final_board_columns
      if [j, i] == coordinates
        for k in 0..calk.length - 1
          for l in 0..calk[0].length - 1
            if (i + k <= final_board_rows && j + l <= final_board_columns)
              if calk[k][l] == " "
                calk[k][l] = "-"
              else
               final_board[i + k][j + l] = calk[k][l]
             end
            else
              puts "Dépassement des limites de la matrice."        
            end
          end
        end
      end
    end
  end
  return final_board
end


def matrix_parsing(matrix, calk)
  matrix_columns = matrix[0].length - 1
  matrix_rows = matrix.length - 1

  for i in 0..matrix_rows
    for j in 0..matrix_columns
      if is_form_first_value?(matrix[i][j], calk) #On vérifie que la valeur actuelle == à la première valeure de la forme
        if create_submatrix_to_calk_dimensions(matrix, i, j, calk)
          coordinates = [j, i]
          display_coordinates = "#{j},#{i}"
          final_board = final_matrix_display(matrix, calk, coordinates)
          final_board = from_matrix_to_text(final_board)
          return "Trouvé ! \nCoordonnées : #{display_coordinates}\n#{final_board}"
        end
      end    
    end 
  end
  return "Introuvable"
end


#Partie 2 : Gestion d'erreur
if !main_matrix.include?(".txt") || !calk_matrix.include?(".txt")
  puts "error"
  exit
end

if ARGV.length != 2
  puts "error : Only 2 filenames needed"
  exit
end

#Partie 3 : Résolution
main_matrix = from_text_to_matrix("#{main_matrix}")
calk_matrix = from_text_to_matrix("#{calk_matrix}")

#Partie 4 : Affichage
puts matrix_parsing(main_matrix,calk_matrix)
