// eslint-disable-next-line no-unused-vars
import { createApp } from 'vue';
import lux from 'lux-design-system';
// we need to import Rails so vite adds it to the module
import Rails from '@rails/ujs'; // eslint-disable-line no-unused-vars
import CopyToClipboard from '../components/copy_to_clipboard'; // eslint-disable-line no-unused-vars
import LockerSizeFilter from '../components/locker_size_filter'; // eslint-disable-line no-unused-vars
import 'lux-design-system/dist/style.scss';
import 'lux-design-system/dist/style.css';

const app = createApp({});
const createMyApp = () => createApp(app);

document.addEventListener('DOMContentLoaded', () => {
  document.getElementsByTagName('html')[0].classList.remove('loading');
  const elements = document.getElementsByClassName('lux');
  for (let i = 0; i < elements.length; i++) {
    createMyApp().use(lux).mount(elements[i]);
  }
  new CopyToClipboard();
  new LockerSizeFilter();
});
