export default class LockerSizeFilter {
  constructor() {
    this.preferredFloor = document.querySelector(
      '#locker_application_preferred_general_area'
    );
    this.preferredSize = document.querySelector(
      '#locker_application_preferred_size'
    );
    this.library = document
      .querySelector('#locker-form-header a')
      .innerHTML.split(' ')[0];
    this.#addListener();
  }

  #addListener() {
    this.preferredFloor.addEventListener('change', () => {
      if (this.library === 'Firestone') {
        if (this.preferredFloor.value === 'A floor') {
          this.preferredSize.options.length = 0;
          this.preferredSize[0] = new Option('6-foot', 6);
        } else {
          this.preferredSize.options.length = 0;
          this.preferredSize[0] = new Option('4-foot', 4);
          this.preferredSize[1] = new Option('6-foot', 6);
        }
      }
    });
  }
}
