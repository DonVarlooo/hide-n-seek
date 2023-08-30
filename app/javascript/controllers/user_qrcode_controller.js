import { Controller } from "@hotwired/stimulus"
import QRCode from 'qrcode'

// Connects to data-controller="user-qrcode"
export default class extends Controller {
  connect() {
    console.log("Je suis co");
  }
}


  //   @qrcode = RQRCode::QRCode.new("1")

  //   @svg = @qrcode.as_svg(
  //     color: "000",
  //     shape_rendering: "crispEdges",
  //     module_size: 11,
  //     standalone: true,
  //     use_path: true
  //   )
