import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="resetform"
export default class extends Controller {
  reset() {
    this.element.reset()

    const submitButton = this.element.querySelector('input[type="submit"], button[type="submit"]')
    
    // Disable the submit button temporarily
    if (submitButton) {
      submitButton.disabled = true
      const originalText = submitButton.value || submitButton.textContent
      
      // Update button text to show countdown (optional)
      let countdown = 3
      const updateButton = () => {
        if (submitButton.tagName === 'INPUT') {
          submitButton.value = `Wait ${countdown}s...`
        } else {
          submitButton.textContent = `Wait ${countdown}s...`
        }
      }
      
      updateButton()
      
      const countdownInterval = setInterval(() => {
        countdown--
        if (countdown > 0) {
          updateButton()
        } else {
          clearInterval(countdownInterval)
          // Re-enable button and restore original text
          submitButton.disabled = false
          if (submitButton.tagName === 'INPUT') {
            submitButton.value = originalText
          } else {
            submitButton.textContent = originalText
          }
        }
      }, 1000)
    }
    
  }
}
