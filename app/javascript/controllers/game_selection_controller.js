import { Controller } from "@hotwired/stimulus"
import haversine from 'haversine-distance'

// Connects to data-controller="game-selection"
export default class extends Controller {
  static targets = ["items", "latitude", "longitude", "form", "return", "btn", 'btnSubmit']

  connect() {
    const options = {
      enableHighAccuracy: true
    };
    navigator.geolocation.getCurrentPosition(this.success.bind(this), this.error, options);
  }

  success(pos) {
    const crd = pos.coords;

    this.latitudeData = crd.latitude
    this.longitudeData = crd.longitude

    // Mise a jour form
    this.latitudeTarget.value = crd.latitude
    this.longitudeTarget.value = crd.longitude

    // Enable submit submit button
    this.btnSubmitTarget.removeAttribute("disabled")

    console.log(pos.coords)
    this.addCoord()
  }

  error(err) {
    console.error(`ERROR(${err.code}): ${err.message}`);
    console.trace()
  }

  addCoord() {
    const url = `/games?lat=${this.latitudeData}&lng=${this.longitudeData}`;
    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => {
        // console.log(data.partial);

        this.itemsTarget.innerHTML = data.partial;
        this.spaceBetween();
      })
  }

  popUp(event) {
    event.preventDefault();
    this.formTarget.classList.toggle("d-none")
    this.returnTarget.classList.add("d-none")
    event.currentTarget.classList.add("d-none")
  }

  spaceBetween() {
    this.btnTargets.forEach((btn) => {
      const positionGame = {lat: parseFloat(btn.dataset.latitude), lng: parseFloat(btn.dataset.longitude)};
      const position = {lat: this.latitudeData, lng: this.longitudeData};
      const distance = Math.round(haversine(position, positionGame) / 1000);

      btn.insertAdjacentHTML('beforeend', `duration ${btn.dataset.duration}min (${distance}km)`);
    })
  }
}
