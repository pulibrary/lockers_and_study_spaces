import CopyToClipboard from '#components/copy_to_clipboard.js';

describe('CopyToClipboard', () => {
  let clipboardData = '';

  beforeEach(() => {
    const mockClipboard = {
      writeText: (data) => {
        clipboardData = data;
        return Promise.resolve();
      },
    };
    global.navigator.clipboard = mockClipboard;
  });

  it('sets the button text to Copied!', async () => {
    document.body.innerHTML =
      '<div id="123">456</div><button id="button" class="copy-to-clipboard" aria-live="assertive" data-text-element="123"></button>';
    new CopyToClipboard();
    await document.getElementById('button').click();
    expect(document.getElementById('button').innerText).toBe('Copied!');
  });

  it('adds text from the specified element to the clipboard', async () => {
    document.body.innerHTML =
      '<div id="123">456</div><button id="button" class="copy-to-clipboard" aria-live="assertive" data-text-element="123"></button>';
    new CopyToClipboard();
    await document.getElementById('button').click();
    expect(clipboardData).toBe('456');
  });
});
