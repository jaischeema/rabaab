import React           from 'react';
import SM              from 'soundmanager2';
import { Link }        from 'react-router';
import PlayerControls  from './player_controls';
import SearchBar       from './search_bar';
import PlaylistSection from './playlist_section';
import { Playlist }    from '../playlist';

export default class Rabaab extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      canPlay:          false,
      currentSong:      null,
      paused:           false,
      loadingSong:      true,
      currentPosition:  0,
      totalDuration:    0,
      percentageLoaded: 0
    };
    this.destroyCurrentSound = this.destroyCurrentSound.bind(this);
  }

  componentDidMount() {
    this.unsubscribe = Playlist.listen(this.onPlaylistChange.bind(this));
    soundManager.onload = () => {
      this.setState({canPlay: true }, this.onPlaylistChange.bind(this));
    }
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  destroyCurrentSound() {
    if(this.currentSound !== undefined) {
      this.currentSound.destruct();
    }
  }

  onPlaylistChange() {
    if(Playlist.currentIndex == null) {
      this.setState({currentSong: null}, this.destroyCurrentSound)
      return
    }
    var song = Playlist.songs[Playlist.currentIndex];
    if(this.state.currentSong != song) {
      this.destroyCurrentSound();
      this.playSong(song);
    } else {
      if(Playlist.playing && this.state.paused) {
        this.currentSound.play();
        this.setState({paused: false});
      } else if (!Playlist.playing && !this.state.paused) {
        this.currentSound.pause();
        this.setState({paused: true});
      }
    }
  }

  render() {
    return (
      <div className="container-fluid">
        <div className="header">
          <Link to="/" className="brand">Rabaab</Link>
          <SearchBar
            onSearch={this.search.bind(this)}
            params={this.props.location.query}
          />
        </div>
        <div className="row">
          <div className="content col-sm-9">
            {this.props.children}
          </div>

          <PlaylistSection />
        </div>
        <PlayerControls
          paused={this.state.paused}
          song={this.state.currentSong}
          loading={this.state.loadingSong}
          currentPosition={this.state.currentPosition}
          totalDuration={this.state.totalDuration}
          percentageLoaded={this.state.percentageLoaded}
        />
      </div>
    );
  }

  search(query, type) {
    this.context.router.replaceWith('search', {query: query, type: type});
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
      paused:           false,
      currentSong:      song,
      loadingSong:      true,
      currentPosition:  0,
      totalDuration:    0,
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

Rabaab.contextTypes = {
  router: React.PropTypes.isRequired
};

