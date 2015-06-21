import React from 'react';
import Spinner from './spinner';
import AlbumList from './album_list';
import { Link } from 'react-router';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {albums: [], loading: true};
    var self = this;
    $.getJSON('http://squirrel.jaischeema.com/api/albums/latest', ((response) => {
      this.setState({albums: response.albums, loading: false});
    }));
  }

  render() {
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
        <div className="content">
          <div className="page-title">
            <h1>Latest Albums</h1>
          </div>
          <AlbumList albums={this.state.albums} />
        </div>
      );
    }
  }
}
