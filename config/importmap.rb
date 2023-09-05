# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@2.15.0/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin "@turf/circle", to: "https://ga.jspm.io/npm:@turf/circle@6.5.0/dist/es/index.js"
pin "@turf/destination", to: "https://ga.jspm.io/npm:@turf/destination@6.5.0/dist/es/index.js"
pin "@turf/helpers", to: "https://ga.jspm.io/npm:@turf/helpers@6.5.0/dist/es/index.js"
pin "@turf/invariant", to: "https://ga.jspm.io/npm:@turf/invariant@6.5.0/dist/es/index.js"
pin "qr-scanner", to: "https://ga.jspm.io/npm:qr-scanner@1.4.2/qr-scanner.min.js"
pin "@rails/actioncable", to: "https://cdn.jsdelivr.net/npm/@rails/actioncable@7.0.7-2/app/assets/javascripts/actioncable.esm.js"
pin "haversine-distance", to: "https://ga.jspm.io/npm:haversine-distance@1.2.1/index.js"

pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.6.0/dist/confetti.module.mjs"
