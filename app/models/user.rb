class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_many :games
  has_many :user_games
  has_many :games_as_opponent, through: :user_games, source: :game

  def qrcode
    qrcode = RQRCode::QRCode.new(id.to_s)

    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end

  def find_user_game(game)
    UserGame.find_by(game: game, user: self)
  end

  def winstreak
    current_streak = 0
    user_games.each do |game|
      if game.win
        current_streak += 1
      else
        current_streak = 0
      end
    end
    return current_streak
  end

  def face_to_face(opponent_user)
    win = 0
    loose = 0

    games_participated = games_as_opponent.where(status: :finished)
    # On doit récuperer nos games et aussi celle que l'opponent à creer !
    # On ne récupère pas la seconde partie des games ce qui fait que nos stats sont fausses !
    games_with_opponent_user = games_participated.select do |game|
      game.user_games.extract_associated(:user).include?(opponent_user)
    end

    face_to_face_user_games = UserGame.where('user_id = ? AND game_id = ANY(ARRAY[?]::int[])', id, games_with_opponent_user.pluck(:id))
    face_to_face_user_games.each do |game|
      if game.win
        win += 1
      else
        loose += 1
      end
    end
    return "#{win}W / #{loose}L"
  end
end
