require('./assets/bootstrap.min.css');
require('./assets/font-awesome.css');
require('./assets/main.css');

const Elm  = require('./Main.elm');
const root = document.getElementById('root');
const app  = Elm.Main.embed(root);

var audio = new Audio();

app.ports.setSource.subscribe((source) => {
  audio.src = source;
  audio.load();
  audio.play();
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
