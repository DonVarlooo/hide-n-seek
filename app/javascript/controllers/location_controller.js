import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import circle from "@turf/circle";

export default class extends Controller {
  static targets = ["startTracking", "map"]

  static values = {
    apiKey: String,
    markers: Array,
    areaCenterLat: Number,
    areaCenterLng: Number,
    areaRadius: Number
  }

  connect() {
    this.markers = []
    this.#buildMap()
  }

  // MAP FUNCTIONS

  #buildMap() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/hugochaa/cllz02ns400n701pfa46nfs93"
    })

    this.map.on('load', () => {
      this.#addGameAreaTomap()
      this.#getUserPosition()

      navigator.geolocation.watchPosition((data) => {
        this.animateMarker(data.coords.latitude, data.coords.longitude)
        this.#saveCoordinatesToLocalStorage(data.coords.latitude, data.coords.longitude)
      })
    });
  }

  #addGameAreaTomap() {
    const center  = [this.areaCenterLngValue, this.areaCenterLatValue];
    console.log(center)
    const radius  = this.areaRadiusValue * 0.025;
    const options = {steps: 100, units: 'kilometers'};

    const circleGeojson = circle(center, radius, options);

    this.map.addLayer({
      "id": "circle",
      "type": "fill",
      "source": {
        "type": "geojson",
        "data": circleGeojson,
        "lineMetrics": true,
      },
      "paint": {
        "fill-color": "#C2A83E",
        "fill-opacity": 0.5,
        "fill-outline-color": "#C2A83E",
      },
      "layout": {}
    });

    this.#fitMapToGameArea()
  }


  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      var marker = new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
      this.markers.push(marker)
    })
  }

  #fitMapToGameArea() {
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend([this.areaCenterLngValue, this.areaCenterLatValue])

    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()

    bounds.extend([this.areaCenterLngValue, this.areaCenterLatValue])
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))

    this.map.fitBounds(bounds, { padding: 70, maxZoom: 14, duration: 0 })
  }

  // GEOLOCATION FUNCTIONS

  #getUserPosition() {
    const options = {
      enableHighAccuracy: true
    };

    this.#setMarkerFromLocalStorage()
    navigator.geolocation.getCurrentPosition(this.#success.bind(this), this.#error.bind(this), options)
  }

  #success(pos) {
    const crd = pos.coords;

    this.#handleGetUserPosition(crd.latitude, crd.longitude)
  }

  #error(err) {
    console.warn(`ERROR(${err.code}): ${err.message}`);
    console.trace()
    this.#getUserPosition()
    const coords = JSON.parse(localStorage.getItem('coords'))
    this.#handleGetUserPosition(coords.lat, coords.lon)
  }

  #handleGetUserPosition(latitude, longitude) {
    this.#saveCoordinatesToLocalStorage(latitude, longitude)

    this.latitude = latitude
    this.longitude = longitude


    this.markersValue = [{lng: longitude, lat: latitude}]

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  animateMarker(lat, lon) {
    const marker = this.markers[0]
    if (marker === undefined) {
      this.markersValue = [{lng: lon, lat: lat}]

      this.#addMarkersToMap()
      this.#fitMapToMarkers()
    } else {

      marker.setLngLat([
        lon, lat
      ]);

      marker.addTo(this.map);
    }
  }

  #saveCoordinatesToLocalStorage(lat, lon) {
    const coords = {
      lat: lat,
      lon: lon
    }
    localStorage.setItem('coords', JSON.stringify(coords))
  }

  #setMarkerFromLocalStorage() {
    const coords = JSON.parse(localStorage.getItem('coords'))
    if (coords === null) { return }

    this.markersValue = [{lng: coords.lon, lat: coords.lat}]
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }
}
