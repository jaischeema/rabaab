require('./assets/bootstrap.min.css');
require('./assets/font-awesome.css');
require('./assets/main.css');

var t = require('./assets/images/artwork.png');

const Elm  = require('./Main.elm');
const root = document.getElementById('root');
const app  = Elm.Main.embed(root);

const audio = new Audio();

audio.oncanplay = function(e) {
  audio.play();
};

audio.ondurationchange = function(e) {
  app.ports.duration.send(audio.duration);
};

audio.onprogress = function(e) {
  var percentage = 0.0;
  if(audio.buffered.length > 0) {
    var bufferedEnd = audio.buffered.end(audio.buffered.length - 1);
    var duration = audio.duration;
    if (duration > 0) {
      percentage = (bufferedEnd / duration) * 100;
    }
  }
  console.log(percentage);
  app.ports.progress.send(percentage);
};

audio.onended = function() {
  app.ports.endItem.send(audio.currentSrc);
};

audio.ontimeupdate = function(e) {
  app.ports.currentTime.send(audio.currentTime);
};

audio.onplay = function(e) {
  app.ports.state.send('playing');
};

audio.onplaying = function(e) {
  app.ports.state.send('playing');
};

audio.onpause = function(e) {
  app.ports.state.send('paused');
};

app.ports.setSource.subscribe((source) => {
  audio.src = source;
  audio.load();
  app.ports.state.send('loading');
});

app.ports.setCurrentTime.subscribe((time) => {
  audio.currentTime = time;
});

app.ports.setPlaybackRate.subscribe((rate) => {
  audio.playbackRate = rate;
});

app.ports.play.subscribe(() => {
  audio.play();
});

app.ports.pause.subscribe(() => {
  audio.pause();
});
