import React from 'react';
import SM from 'soundmanager2';
import PlayerControls from './player_controls';
import { Link } from 'react-router';
import { Playlist } from '../playlist';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      canPlay:         false,
      currentSong:     null,
      paused:          false,
      loadingSong:     true,
      currentPosition: 0,
      totalDuration:   0,
      percentageLoaded: 0
    };
  }

  componentDidMount() {
    soundManager.onload = () => {
      this.setState({canPlay: true });
    }
    this.unsubscribe = Playlist.listen(this.onPlaylistChange.bind(this));
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  onPlaylistChange() {
    var song = Playlist.songs[Playlist.currentIndex];
    if(this.state.currentSong != song) {
      if(this.currentSound !== undefined) {
        this.currentSound.destruct();
      }
      this.playSong(song);
    } else {
      if(Playlist.playing && this.state.paused) {
        this.currentSound.play();
        this.setState({
          paused: false
        });
      } else if (!Playlist.playing && !this.state.paused) {
        this.currentSound.pause();
        this.setState({
          paused: true
        });
      }
    }
  }

  render() {
    return (
      <div className="container-fluid">
        <nav className="navbar navbar-default navbar-fixed-top">
          <div className="container-fluid">
            <div className="navbar-header">
              <a className="navbar-brand">Rabaab</a>
            </div>
            <ul className="nav navbar-nav">
              <li><Link to="/">Latest Albums</Link></li>
              <li><Link to="/search">Search</Link></li>
            </ul>
          </div>
        </nav>

        <div className="content">
          {this.props.children}
        </div>

        <div className="navbar-fixed-bottom navbar navbar-inverse">
          <PlayerControls
            paused={this.state.paused}
            song={this.state.currentSong}
            loading={this.state.loadingSong}
            currentPosition={this.state.currentPosition}
            totalDuration={this.state.totalDuration}
            percentageLoaded={this.state.percentageLoaded}
          />
        </div>
      </div>
    );
  }

  onPlayButtonClick() {
    if(this.state.paused) {
      this.setState({paused: false});
      this.currentSound.play();
    } else {
      this.currentSound.pause();
      this.setState({paused: true});
    }
  }

  renderSong(song) {
    return (
      <li onClick={this.playSong.bind(this, song)}>
        {song.title}
      </li>
    );
  }

  playSong(song) {
    if(this.state.canPlay == false) return;

    var self = this;
    this.currentSound = soundManager.createSound({
      id: `sound-${song.resource_id}`,
      url: song.normal_quality_url,
      autoLoad: true,
      autoPlay: true,
      onload: this.onSongLoad.bind(this),
      whileloading: this.whileLoading.bind(this),
      whileplaying: this.whilePlaying.bind(this),
      onfinish: self.onFinish(this),
    });

    this.setState({
      currentSong: song,
      loadingSong: true,
      currentPosition: 0,
      totalDuration:   0,
      percentageLoaded: 0
    });
  }

  onSongLoad() {
    this.setState({loadingSong: false});
  }

  whileLoading() {
    this.setState({
      percentageLoaded: (this.currentSound.bytesLoaded / this.currentSound.bytesTotal)
    });
  }

  whilePlaying() {
    this.setState({
      currentPosition: this.currentSound.position,
      totalDuration: this.currentSound.duration
    });
  }

  onFinish() {
    console.log("song finished");
  }
}
