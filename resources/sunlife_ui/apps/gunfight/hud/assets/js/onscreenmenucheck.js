$(document).ready(function(){
    window.addEventListener('message', (event) => {
      if (event.data.type === 'screenshotcheck') {
        Tesseract.recognize(
          event.data.screenshoturl,
          'eng'
          // { logger: m => console.log(JSON.stringify(m)) }
        ).then(({ data: { text } }) => {
            $.post('https://sunlife_ui/gunfight/check', JSON.stringify({text}));
        });
      }
    });
});