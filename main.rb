require './lib/chess.rb'
require './lib/player.rb'
require './lib/pieces.rb'


game = Chess.new(WhitePlayer, BlackPlayer)

game.add_pieces_to_board

