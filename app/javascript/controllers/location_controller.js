import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static targets = ["startTracking", "map"]
  static values = {
    apiKey: String,
    markers: Array
  }


  connect() {
    this.markers = []
    const options = {
      enableHighAccuracy: true,
      timeout: 5000,
      maximumAge: 0,
    };

    const success = (pos) => {
      const crd = pos.coords;

      console.log("Your current position is:");
      console.log(`Latitude : ${crd.latitude}`);
      console.log(`Longitude: ${crd.longitude}`);
      console.log(`More or less ${crd.accuracy} meters.`);
      this.markersValue = [{lng: crd.longitude, lat: crd.latitude}]
      this.#buildMap()
    }

    function error(err) {
      console.warn(`ERROR(${err.code}): ${err.message}`);
    }

    console.log(navigator.geolocation.getCurrentPosition(success, error, options));
    navigator.geolocation.watchPosition((data) => {
      this.animateMarker(data.coords.latitude, data.coords.longitude)
    })
  }

  #buildMap() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      var marker = new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
      this.markers.push(marker)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  animateMarker(lat, lon) {
    console.log("haha")
    const marker = this.markers[0]
    marker.setLngLat([
      lon, lat
    ]);
    marker.addTo(this.map);
  }
}