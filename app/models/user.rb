class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_many :games
  has_many :user_games

  # geocoded_by :lat
  # geocoded_by :lng
  # after_validation :geocode, if: :will_save_change_to_lat?
  # after_validation :geocode, if: :will_save_change_to_lng?

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
end
