import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submit-loader"
export default class extends Controller {
  static targets = ["submit"];

  connect() {
    console.log("Form submit loader controller connected...");
      this.originalButtonContent = this.submitTarget.innerHTML;
  }

  submit() {
      // Replace the button content with a loading spinner
      this.submitTarget.innerHTML = '<span class="loading-spinner"></span>';
      this.submitTarget.disabled = true;

      // Optional: You might want to ensure the form is submitted programmatically
      // this.element.submit();
  }
}
