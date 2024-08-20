import { createApp } from 'vue';
import lux from 'lux-design-system';
import Rails from '@rails/ujs';
import CopyToClipboard from '../components/copy_to_clipboard';
import LockerSizeFilter from '../components/locker_size_filter';
import 'lux-design-system/dist/style.scss';
import 'lux-design-system/dist/style.css';

const app = createApp({});
const createMyApp = () => createApp(app);
Rails.start();

document.addEventListener('DOMContentLoaded', () => {
  document.getElementsByTagName('html')[0].classList.remove('loading');
  const elements = document.getElementsByClassName('lux');
  for (let i = 0; i < elements.length; i++) {
    createMyApp().use(lux).mount(elements[i]);
  }
  new CopyToClipboard();
  new LockerSizeFilter();
});
