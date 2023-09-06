import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game-selection"
export default class extends Controller {
  static targets = ["items", "latitude", "longitude", "form"]

  connect() {
    const options = {
      enableHighAccuracy: false
    };
    navigator.geolocation.getCurrentPosition(this.success.bind(this), this.error, options);
  }

  success(pos) {
    const crd = pos.coords;
    this.latitudeData = crd.latitude
    this.longitudeData = crd.longitude
  }

  error(err) {
    console.warn(`ERROR REMATCH(${err.code}): ${err.message}`);
  }

  addCoords(event) {
    event.preventDefault();

    this.latitudeTarget.value = this.latitudeData
    this.longitudeTarget.value = this.longitudeData
    this.formTarget.submit();
  }
}
