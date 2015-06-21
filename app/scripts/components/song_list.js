import React       from 'react';
import { Link }    from 'react-router';
import ImageLoader from 'react-imageloader';
import { PlaylistActions } from '../playlist';

export default class extends React.Component {
  render() {
    return (
      <div className="song-list">
        {this.props.songs.map((song) => { return this.renderSong(song) }) }
      </div>
    );
  }

  renderSong(song) {
    return (
      <div className="song">
        <span className="title">{song.title}</span>
        <div className="artist">
          <span>{song.artist_title}</span>
          {this.renderAlbumLink(song)}
        </div>
        <div className="actions">
          <i onClick={this.playSong.bind(this, song, false)} className="icon-plus" />
          <i onClick={this.playSong.bind(this, song, true)} className="icon-control-play" />
        </div>
      </div>
    );
  }

  renderAlbumLink(song) {
    if(this.props.showAlbum) {
      return (
        <Link to={`/album/${song.album_id}/${song.album_title}`}>
          <span>&nbsp;&mdash;&nbsp;</span>
          {song.album_title}
        </Link>
      );
    }
  }

  playSong(song, immediate) {
    debugger
    if(immediate) {
      PlaylistActions.playSong(song);
    } else {
      PlaylistActions.add(song);
    }
  }
}
