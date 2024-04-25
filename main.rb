require './lib/chess.rb'
require './lib/player.rb'
require './lib/pieces.rb'


game = Chess.new(WhitePlayer, BlackPlayer)

game.add_pieces_to_board
game.print_board
game.current_player.move("b2", "b4")
# game.switch_player
game.print_board
