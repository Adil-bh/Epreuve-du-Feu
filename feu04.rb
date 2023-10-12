#Fonction utilisées
def boardMaker(arguments)
    boardString = ""

    if arguments.count != 3
        puts "params needed: x y density"
        exit
    end

    x = arguments[0].to_i
    y = arguments[1].to_i
    density = arguments[2].to_i

    #puts "#{y}.xo"
    boardString << "#{y}.xo\n"
    for i in 0..y do
        for j in 0..x do
            #print ((rand(y) * 2 < density) ? 'x' : '.')
            boardString << ((rand(y) * 2 < density) ? 'x' : '.')
        end
        boardString << "\n"
        #print "\n"
    end
    return boardString
end

def writeBoardInFile(board)
    if File.exists?("plateau.txt")
        File.delete("plateau.txt")
    end

    file = File.new('plateau.txt', 'w')
    file.write(board)
    file.close
end

def fromBoardInFileToMatrix(filename)
    boardMatrix = []
    file = File.open("#{filename}", "r")
    file.each_line do |line|
        line = line.split('')
        line.pop
       boardMatrix << line
    end
    return boardMatrix
end

def matrixDisplayer(matrix)
    matrix.each do |line|
        puts "#{line.join}"
    end
end

def squareValid?(matrix, x, y, squareDimension, obstacle, emptySpace, fullSpace)
    xMax = matrix[0].length - 1
    yMax = matrix.length - 1

    for i in y..(y + squareDimension)
        for j in x..(x + squareDimension)
            if matrix[i][j] == emptySpace || matrix[i][j] == obstacle
                return false
            elsif x + squareDimension > xMax || y + squareDimension > yMax
                break
            end
        end
    end

    return true
end

def squareSearch(matrix, x, y, squareDimension, obstacle, emptySpace, fullSpace)
    xMax = matrix[0].length - 1
    yMax = matrix.length - 1
    matrix_copy = matrix.dup.map(&:dup)  # Créez une copie de la matrice d'origine

    
    for i in y..(y + squareDimension)
        for j in x..(x + squareDimension)
            if x + squareDimension > xMax || y + squareDimension > yMax
                break
            elsif matrix_copy[i][j] == emptySpace
                matrix_copy[i][j] = fullSpace
            end
        end
    end

    if squareValid?(matrix_copy, x, y, squareDimension, obstacle, emptySpace, fullSpace)
        # puts " "
        # puts "squareDimension #{squareDimension}"
        # puts "x : #{x} | y : #{y}"
        # matrix_copy.each do |line|
        #     puts "#{line}"
        # end
        return matrix_copy, x, y, squareDimension  # Renvoie la copie modifiée de la matrice
    else
        return false
    end
end

def mainMatrixParsing(matrix)
    xMax = matrix[0][0].to_i
    yMax = matrix[0][0].to_i
    emptySpace = matrix[0][1]
    obstacle = matrix[0][2]
    fullSpace = matrix[0][3]
    matrix.delete(matrix[0]) #Suppression de la première ligne contenant les informations pour lire la grille
    squareDimension = xMax
    matrixWithSquare = []
    currentMatrix = []

    for k in 0..squareDimension 
        for y in 0..yMax - 1
            for x in 0..xMax - 1
                currentMatrix = squareSearch(matrix.dup, x, y, k, obstacle, emptySpace, fullSpace)
                if currentMatrix == false
                    next
                elsif matrixWithSquare.empty? || currentMatrix[3] > matrixWithSquare[3]
                    matrixWithSquare = currentMatrix
                end
            end
        end     
    end
    if !matrixWithSquare.empty?
        return matrixWithSquare[0]
    else
        matrix
    end
end

#Partie 1 : Gestion d'erreur
if ARGV.length != 3
    puts "error : params needed: x y density"
    exit 
end

#Partie 2 : Parsing
board = boardMaker(ARGV)
writeBoardInFile(board)
boardMatrix = fromBoardInFileToMatrix("plateau.txt")

#Partie 3 : Résolution
result = mainMatrixParsing(boardMatrix)

#Partie 4 : Affichage
matrixDisplayer(result)


