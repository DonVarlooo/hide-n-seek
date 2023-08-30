class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo

  geocoded_by :latitude
  geocoded_by :longitude
  after_validation :geocode, if: :will_save_change_to_latitude?
  after_validation :geocode, if: :will_save_change_to_longitude?

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
end
