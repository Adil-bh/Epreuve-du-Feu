=begin
*Fonctionne bien lorsqu'il y a max. 2 chiffres à trouver sur une ligne; revoir la manière de parser lignes et colonnes

Algo :
* Passer le fichier txt en une matrice
* Ensuite on va parcourir la matrice en examinant les blocs de 9
* Si bloc de 9 contient un "." on le complète par le chiffre manquant sinon passer au suivant
* Ce parsing nous donne une grille avec quelques points complétés mais sous forme de blocs séparés, on passe cette grille au même format 
que la grille principale.
* Maintenant faire parsing ligne et colonnes
* Parsing ligne : On parcours ligne par ligne la grille, si sur une ligne on trouve une correspondance à nos solutions 
["1", "2", "3", "4", "5", "6", "7", "8", "9"] on la supprime du tableau jusqu'à obtenir la solution restante (Pb : Si la taille tableau > 1 plusieurs solutions)
* Parsing colonne : On crée un tableau à partir de l'index y pour comparer aux solutions ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
si sur une colonne on trouve une correspondance à nos solution on la supprime du tableau jusqu'à obtenir la solution restante
* Grille résolue
* Afficher grille

=end

require 'colorize'

#Fonction utilisées
def from_textfile_to_matrix(filename)
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

def sudoku_block_parsing(full_grid, y, x)
    block = []
    (x..x+2).step(1) do |x|
        (y..y+2).step(1) do |y|
            block << full_grid[x][y]
        end
    end  
    block = block.each_slice(3).to_a
    #puts "#{block}"
    return block
end

def contains_one_dot_in_block?(block)
    dots_count = 0

    block.each do |row|
        if row.include?(".")
            dots_count += row.count(".")
        end
    end
    dots_count == 1 ? true : false
end

def block_solver(block)
    solutions = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    for i in 0..block.length - 1
        for j in 0..block[0].length - 1
            if solutions.include?(block[i][j])
                solutions.delete(block[i][j])
            end
        end
    end


    for i in 0..block.length - 1
        for j in 0..block[0].length - 1
            if block[i][j] == "."
                block[i][j] = solutions[0].green
            end
        end
    end
    #puts "#{block}"
end

def from_blocks_grid_to_sudoku_grid(grid_of_blocks)
  sudoku_grid = []

  (0..8).step(3) do |i|
    (0..2).each do |j|
      block = []
      (0..2).each do |k|
        block.concat(grid_of_blocks[i + k][j])
      end
      sudoku_grid << block
    end
  end

  return sudoku_grid
end

def from_main_grid_to_grid_solved_blocks(full_grid)
    grid_with_solved_blocks = []

    (0..full_grid[0].length - 1).step(3) do |x_index|
        (0..full_grid.length - 1).step(3) do |y_index|
            block = sudoku_block_parsing(full_grid, y_index, x_index)   
            if contains_one_dot_in_block?(block)
                block_solver(block)
            end
            grid_with_solved_blocks << block
        end
    end
    return grid_with_solved_blocks
end

def parse_line(full_grid, x)
    solutions = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    line_to_parse = full_grid[x]

    if line_to_parse.count(".") == 1
        for i in 0..line_to_parse.length
            if solutions.include?(line_to_parse[i])
                solutions.delete(line_to_parse[i])
            end
        end

        for j in 0..line_to_parse.length
            if line_to_parse[j] == "."
                line_to_parse[j] = solutions[0].green
            end
        end
    end

    return line_to_parse
end

def parse_columns(full_grid, y)
    solutions = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    columns_to_parse = []

    full_grid.each do |line|
        columns_to_parse << line[y]
    end

    columns_to_parse.each do |value|
        if solutions.include?(value)
            solutions.delete(value)
        end
    end

    for i in 0..columns_to_parse.length - 1
        if columns_to_parse[i] == "."
            columns_to_parse[i] = solutions[0]
            return columns_to_parse[i].green
        else
        end
    end
end

def parse_lines_and_cols(grid)
    for i in 0..grid.length - 1
        for j in 0..grid[0].length - 1
            if grid[i][j] == "."
                if parse_line(grid, i).count(".") == 0
                    grid[i] = parse_line(grid, i)
                else
                    grid[i][j] = parse_columns(grid, j)
                end
            end
        end
    end
    return grid
end

def display_grid_to_string(grid)
    grid.each do |line|
        puts "#{line.join}"
    end
end


def sudoku_grid_parsing(full_grid)  
    grid_with_solved_blocks = from_main_grid_to_grid_solved_blocks(full_grid)
    grid_with_solved_blocks = from_blocks_grid_to_sudoku_grid(grid_with_solved_blocks)
    resolved_grid = parse_lines_and_cols(grid_with_solved_blocks)
    return resolved_grid
end


#Partie 1 : Gestion d'erreur
if !ARGV[0].include?(".txt")
    puts "error"
    exit
end

if ARGV.length != 1
    puts "error"
    exit
end

if !File.exists?(ARGV[0])
    puts "error"
    exit
end

#Partie 2 : Parsing
sudoku_matrix = from_textfile_to_matrix(ARGV[0])

#Partie 3 : Résolution
resolved_grid = sudoku_grid_parsing(sudoku_matrix)

#Partie 4 : Affichage
display_grid_to_string(resolved_grid)

