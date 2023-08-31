import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game-selection"
export default class extends Controller {
  static targets = ["items", "latitude", "longitude", "form", "return"]


  connect() {
    const options = {
      enableHighAccuracy: true,
      timeout: 5000,
      maximumAge: 0,
    };

    navigator.geolocation.getCurrentPosition(this.success.bind(this), this.error, options);
  }

  success(pos) {
    const crd = pos.coords;

    this.latitudeData = crd.latitude
    this.longitudeData = crd.longitude
    this.latitudeTarget.value = crd.latitude
    this.longitudeTarget.value = crd.longitude

    console.log("Your current position is:");
    console.log(`Latitude : ${this.latitudeData}`);
    console.log(`Longitude: ${this.longitudeData}`);
    this.addCoord()
  }

  error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
  }

  addCoord() {
    const url = `/games?lat=${this.latitudeData}&lng=${this.longitudeData}`
    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => {
        this.itemsTarget.innerHTML = data.partial;
      })
  }

  popUp(event) {
    event.preventDefault();
    this.formTarget.classList.toggle("d-none")
    this.returnTarget.classList.add("d-none")
    event.currentTarget.classList.add("d-none")
  }

}
