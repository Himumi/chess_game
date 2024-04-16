require './lib/chess.rb'
require './lib/player.rb'
require './lib/pieces.rb'

white = WhitePlayer.new('foo')
black = BlackPlayer.new('boo')
# p white.available_pieces
# p black.available_pieces

game = Chess.new(white, black)
# game.pre_game
game.print_board
# game.print_board

# # Kn = Knight.new()
# p white.pieces
# p black.pieces

# kw = King.new("e1", "white")
# kb = King.new("e8", "black")
# p kw.symbol
# p kb.symbol

# p game.board['e8'].key
