import React from 'react';
import { Link } from 'react-router';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {albums: []};
    var self = this;
    $.getJSON('http://squirrel.jaischeema.com/api/albums/latest', ((response) => {
      this.setState({albums: response.albums});
    }));
  }

  render() {
    return (
      <ul>
        {this.state.albums.map((album) => { return this.renderAlbum(album) })}
      </ul>
    );
  }

  renderAlbum(album) {
    return (<li><Link to={`albums/${album.resource_id}/${album.title}`}>{album.title}</Link></li>);
  }
}
