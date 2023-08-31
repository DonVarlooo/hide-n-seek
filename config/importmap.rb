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
pin "qrcode", to: "https://ga.jspm.io/npm:qrcode@1.5.3/lib/browser.js"
pin "dijkstrajs", to: "https://ga.jspm.io/npm:dijkstrajs@1.0.3/dijkstra.js"
pin "encode-utf8", to: "https://ga.jspm.io/npm:encode-utf8@1.0.3/index.js"
