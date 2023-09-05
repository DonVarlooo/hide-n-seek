import { Controller } from "@hotwired/stimulus"
import QrScanner from 'qr-scanner';

export default class extends Controller {
  static targets = [ "video" ]
  static values = {
    scanUrl: String
  }

  connect() {
    this.#initScanner()
  }

  startScanning() {
    this.qrScanner.start()
  }

  stopScanning() {
    this.qrScanner.stop()
  }

  #initScanner() {
    this.qrScanner = new QrScanner(
      this.videoTarget,
      this.#processResult.bind(this),
      { /* your options or returnDetailedScanResult: true if you're not specifying any other options */ },
    );
  }

  #processResult(results) {
    this.stopScanning()
    const data = new FormData
    data.append('opponent_id', results.data)
    const url = this.scanUrlValue
    const options = {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: data
    }

    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        console.log("Processing results of scan", data)
        if (data.success) {
          this.element.closest('#show-game').outerHTML = data.partial
        } else {
          alert('boloss va')
        }
      })
  }

}
