import React from 'react';
import { Playlist, PlaylistActions } from '../playlist';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      songs:       Playlist.songs,
      currentSong: Playlist.songs[Playlist.currentIndex]
    };
  }

  onPlaylistChange() {
    this.setState({
      songs:       Playlist.songs,
      currentSong: Playlist.songs[Playlist.currentIndex]
    });
  }

  componentDidMount() {
    this.unsubscribe = Playlist.listen(this.onPlaylistChange.bind(this));
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  render() {
    return (
      <div className="col-sm-3 playlist-section">
        <h2>Playlist</h2>
        {this.renderContent()}
      </div>
    );
  }

  renderContent() {
    if(this.state.songs.length == 0) {
      return (<span className="no-content">No songs in playlist</span>);
    } else {
      return (
        <div className="songs">
          {this.state.songs.map((song) => { return this.renderSong(song) })}
        </div>
      );
    }
  }

  renderSong(song) {
    return (
      <a onClick={this.playSong.bind(song)} className={(song === this.state.currentSong) ? 'active' : ''}>
        <span className="title">{song.title}</span>
        <span className="artist-title">{song.artist_title}</span>
        <i className="icon-close" onClick={this.removeSongFromPlaylist.bind(song)}></i>
      </a>
    );
  }

  playSong() {
    PlaylistActions.playSong(this);
    event.stopPropagation();
  }

  removeSongFromPlaylist(event) {
    PlaylistActions.remove(this);
    event.stopPropagation();
  }
}
