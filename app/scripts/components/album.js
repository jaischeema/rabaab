import React      from 'react';
import { Link }   from 'react-router';
import Spinner    from './spinner';
import PageHeader from './page_header';

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
        <PageHeader
          title={this.state.album.title}
          subTitle={this.state.album.artist_title}
        />
        {this.renderContent()}
      </div>
    );
  }

  renderContent() {
    if(this.state.loading) {
      return (
        <Spinner
          config={{
            width: 12,
            radius: 25,
          }}
        />
      );
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
