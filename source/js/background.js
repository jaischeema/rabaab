chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('index.html', {
    'bounds': {
      'width': 825,
      'height': 650
    },
    'minWidth': 800,
    'minHeight': 600
  });
});