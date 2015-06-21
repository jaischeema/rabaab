import React       from 'react';
import { Link }    from 'react-router';

export default class extends React.Component {
  render() {
    return (
      <div className="artist-list">
        {this.props.artists.map((artist) => { return this.renderArtist(artist) }) }
      </div>
    );
  }

  renderArtist(artist) {
    return (
      <Link to={`/artists/${artist.resource_id}`} className="artist">
        <span className="title">{artist.title}</span>
      </Link>
    );
  }
}
