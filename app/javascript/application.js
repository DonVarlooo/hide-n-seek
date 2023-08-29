// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import mapboxgl from 'mapbox-gl'; // or "const mapboxgl = require('mapbox-gl');"

import { geoFindMe } from "./controllers/mapbox"

geoFindMe()
