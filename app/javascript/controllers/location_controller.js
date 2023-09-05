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
      this.latitude = crd.latitude
      this.longitude = crd.longitude

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
      style: "mapbox://styles/hugochaa/cllz02ns400n701pfa46nfs93"
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    this.map.on('load', () => {
      var center = [this.areaCenterLngValue, this.areaCenterLatValue];
      var radius = this.areaRadiusValue * 0.025;
      console.log("radius :", radius)
      var options = {steps: 100, units: 'kilometers'};
      // var circleCoords = turf.circle(center, radius, options);
      const circleGeojson = circle(center, radius, options);

      console.log(circleGeojson)

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
        "layout": {

        }
      });
    });
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

    bounds.extend([this.areaCenterLngValue, this.areaCenterLatValue])
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


// Def geocode_center
//   Geocoder::Calculations.geographic_center([[lng user1, lat user1], [lng user2, lat user2]])
// end
