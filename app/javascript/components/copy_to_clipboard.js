export default class CopyToClipboard {
  constructor() {
    this.copyButtons = document.querySelectorAll('.copy-to-clipboard');
    this.#addListeners();
  }

  #addListeners() {
    this.copyButtons.forEach((button) => {
      button.addEventListener('click', () => {
        const textField = document.getElementById(
          button.getAttribute('data-text-element')
        );
        navigator.clipboard.writeText(textField.innerHTML).then(() => {
          button.innerText = 'Copied!';
        });
      });
    });
  }
}
