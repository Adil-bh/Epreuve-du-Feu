#Utilisation de l'algorithme Astar pour trouver le chemin les plus rapide.
#Fonction utilisées
def maze_maker(arguments)
    mazeString = ""
    if arguments.count < 3 || arguments[2].length < 5
      puts "params needed: height width characters"
    else
      height, width, chars, gates = arguments[0].to_i, arguments[1].to_i, arguments[2], arguments[3].to_i
      entry = rand(width - 4) + 2
      entry2 = rand(width - 4) + 2
      mazeString << "#{height}x#{width}#{arguments[2]}\n"
      height.times do |y|
        width.times do |x|
          if y == 0 && x == entry
            mazeString << chars[3].chr
          elsif y == entry2 && x == width - 1
            mazeString << chars[4].chr
          elsif y == height - 1 && x == entry2
            mazeString << chars[4].chr
          elsif y.between?(1, height - 2) && x.between?(1, width - 2) && rand(100) > 20
            mazeString << chars[1].chr
          else
            mazeString << chars[0].chr
          end
        end
        mazeString << "\n"
      end
    end
    return mazeString
end

def write_maze_in_file(maze)
    if File.exists?("labyrinthe.txt")
        File.delete("labyrinthe.txt")
    end

    file = File.new('labyrinthe.txt', 'w')
    file.write(maze)
    file.close
end

def from_maze_in_file_to_matrix(filename)
    mazeMatrix = []
    file = File.open("#{filename}", "r")
    file.each_line do |line|
        line = line.split('')
        line.pop
       mazeMatrix << line
    end
    return mazeMatrix
end

def maze_displayer(matrix)
    matrix.each do |line|
    puts "#{line.join("")}"
    end
end

def get_starting_point(matrix)
    y = 0
    for i in 0..matrix[0].length
        if matrix[0][i] == "1"
            x = i
        end
    end
    start_coordinates = [y,x]
    return start_coordinates
end

def get_first_exit(matrix)
    x = matrix[0].length - 1
    for i in 0..matrix.length - 1
        if matrix[i][x] == "2"
            y = i
        end
    end
    exit_coordinates = [x, y]
    return exit_coordinates
end

def get_second_exit(matrix)
    y = matrix.length - 1
    for i in 0..matrix[0].length
        if matrix[y][i] == "2"
            x = i
        end
    end
    exit_coordinates = [x,y]
    return exit_coordinates
end

class Node
  attr_accessor :parent, :position, :g, :h, :f

  def initialize(parent = nil, position = nil)
    @parent = parent
    @position = position
    @g = 0
    @h = 0
    @f = 0
  end

  def ==(other)
    @position == other.position
  end
end

def astar(maze, start, goal)
  start_node = Node.new(nil, start)
  start_node.g = start_node.h = start_node.f = 0

  end_node = Node.new(nil, goal)
  end_node.g = end_node.h = end_node.f = 0

  open_list = []
  closed_list = []

  open_list << start_node

  until open_list.empty?
    current_node = open_list.min_by { |node| node.f }

    open_list.delete(current_node)
    closed_list << current_node

    if current_node == end_node
      path = []
      while current_node
        path << current_node.position
        current_node = current_node.parent
      end
      return path.reverse
    end

    children = []
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |new_position|
      node_position = [current_node.position[0] + new_position[0], current_node.position[1] + new_position[1]]

      next unless node_position[0].between?(0, maze.length - 1) && node_position[1].between?(0, maze.first.length - 1)
      next if maze[node_position[0]][node_position[1]] == "*"

      new_node = Node.new(current_node, node_position)
      children << new_node
    end

    children.each do |child|
      next if closed_list.include?(child)

      child.g = current_node.g + 1
      child.h = (child.position[0] - end_node.position[0])**2 + (child.position[1] - end_node.position[1])**2
      child.f = child.g + child.h

      next if open_list.include?(child) && child.g > open_list.find { |open_node| open_node == child }.g

      open_list << child
    end
  end

  return nil # Return nil si pas de chemin
end

def choose_shortest_path(path1, path2)
    return path2 if path1.nil?
    return path1 if path2.nil?
    return "Pas de chemin" if path1 == nil && path2 == nil

    length1 = path1.length
    length2 = path2.length

    if length1 < length2
        return path1
    else
        return path2
    end
end

def create_bubble_path(matrix, path)
    coordinates = path
    coordinates.each do |coord|
        x, y = coord
        matrix[x][y] = "o"
    end
    return matrix
end

def main_matrix_parsing(matrix)
    xMax = matrix[0][0]
    xMax << matrix[0][1]
    xMax = xMax.to_i
    yMax = matrix[0][3]
    yMax << matrix[0][4]
    yMax = yMax.to_i
    emptySpace = matrix[0][6]
    obstacle = matrix[0][5]
    path = matrix[0][7]
    entry = matrix[0][8]
    mazeExit = matrix[0][9]
    matrix.shift #Suppression de la première ligne contenant les informations pour lire la grille

    start_point = get_starting_point(matrix)
    first_exit = get_first_exit(matrix)
    second_exit = get_second_exit(matrix)

    startNode = [start_point[0], start_point[1]]
    goalNode = [first_exit[0],first_exit[1]]
    goal2Node = [second_exit[0], second_exit[1]]

    path1 = astar(matrix, startNode, goalNode)
    path2 = astar(matrix, startNode, goal2Node)

    choosen_path = choose_shortest_path(path1, path2)
    if choosen_path != nil
        choosen_path.shift
        choosen_path.pop
        resolved_maze = create_bubble_path(matrix, choosen_path)
    end

    if resolved_maze != nil
        puts "Sortie atteinte en #{choosen_path.length} coups !"
        return resolved_maze
    else
        puts "Pas de chemin"
        return matrix
    end
end

#Partie 1 : Gestion d'erreur
if ARGV.length != 3
    puts "error : Arguments needs to be 'Height : XX' 'Wiidth : XX' Symbols : '* o12' "
    exit
end

#Partie 2 : Parsing
maze = maze_maker(ARGV)
write_maze_in_file(maze)
mazeMatrix = from_maze_in_file_to_matrix("labyrinthe.txt")

#Partie 3 : Résolution

result = main_matrix_parsing(mazeMatrix)

#Partie 4 : Affichage
maze_displayer(result)