
import mapboxgl from 'mapbox-gl'; // or "const mapboxgl = require('mapbox-gl');"

mapboxgl.accessToken = 'pk.eyJ1IjoiaHVnb2NoYWEiLCJhIjoiY2xsdjFuOXJlMWRoMjNrcHBvdzBsNjBuNSJ9.ef0VQFA4MJJ-8E9pVS4fEA';
const map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/mapbox/streets-v12', // style URL
    center: [-74.5, 40], // starting position [lng, lat]
    zoom: 9, // starting zoom
});

function geoFindMe() {
  console.log('eoueoue')
  const status = document.querySelector("#status");
  const mapLink = document.querySelector("#map-link");

  mapLink.href = "";
  mapLink.textContent = "";

  function success(position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;

    status.textContent = "";
    mapLink.href = `https://www.openstreetmap.org/#map=18/${latitude}/${longitude}`;
    mapLink.textContent = `Latitude: ${latitude} °, Longitude: ${longitude} °`;
  }

  navigator.geolocation.getCurrentPosition(success);
}

document.querySelector("#find-me").addEventListener("click", geoFindMe);

export { geoFindMe }
