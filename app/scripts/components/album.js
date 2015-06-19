import React from 'react';
import { Link } from 'react-router';
import { PlaylistActions } from '../playlist';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      album:   {title: props.params.title}
    };

    var id = this.props.params.id;
    $.getJSON(`http://squirrel.jaischeema.com/api/albums/${id}`, ((response) => {
      this.setState({album: response, loading: false});
    }));
  }

  render() {
    return (
      <div className="album">
        <div className="page-header">
          <h1>
            {this.state.album.title}
            <small>{this.state.album.artist_title}</small>
          </h1>
        </div>
        {this.renderContent()}
      </div>
    );
  }

  renderContent() {
    if(this.state.loading) {
      return (<h3>Loading......</h3>);
    } else {
      return (
        <ul>
          {this.state.album.songs.map((song) => { return this.renderSong(song) })}
        </ul>
      );
    }
  }

  renderSong(song) {
    return (<li onClick={this.onSongClick.bind(this, song)}>{song.title}</li>);
  }

  onSongClick(song) {
    PlaylistActions.add(song);
  }
}
