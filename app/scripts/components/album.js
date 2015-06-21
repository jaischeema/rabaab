import React      from 'react';
import { Link }   from 'react-router';
import Spinner    from './spinner';
import SongList   from './song_list';
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
      return ( <SongList songs={this.state.album.songs} /> );
    }
  }
}
