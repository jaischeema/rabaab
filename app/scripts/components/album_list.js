import React       from 'react';
import { Link }    from 'react-router';
import ImageLoader from 'react-imageloader';

export default class extends React.Component {
  render() {
    return (
      <div className="album-list">
        {this.props.albums.map((album) => { return this.renderAlbum(album) }) }
      </div>
    );
  }

  renderAlbum(album) {
    return (
      <Link to={`/albums/${album.resource_id}/${album.title}`} className="album">
        <ImageLoader src={album.album_art}>
          <img src="/images/album-placeholder.png" />
        </ImageLoader>
        <span className="title">{album.title}</span>
        <span className="artist">{album.artist_title}</span>
      </Link>
    );
  }
}
