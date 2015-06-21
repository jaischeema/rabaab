import React from 'react';
import Spinner from './spinner';
import AlbumList from './album_list';
import { Link } from 'react-router';
import PageHeader from './page_header';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {albums: [], loading: true};
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
          <PageHeader title="Latest Albums" />
          <AlbumList albums={this.state.albums} />
        </div>
      );
    }
  }
}
