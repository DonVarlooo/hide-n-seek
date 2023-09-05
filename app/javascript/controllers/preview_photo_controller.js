import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview-photo"
export default class extends Controller {

  // Declare our two targets
  static targets = ["input", "preview"]
  connect() {
    console.log('woooo');
  }
  // Code this callback function
  displayPreview(event) {
    console.log(('wsh'));
    const reader = new FileReader();
    reader.onload = (event) => {
      this.previewTarget.classList.remove('d-none')
      this.previewTarget.src = event.currentTarget.result;
    }
    reader.readAsDataURL(this.inputTarget.files[0])
    this.previewTarget.classList.remove('hidden');
  }
}
