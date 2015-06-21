import React               from 'react';
import Spinner             from './spinner';
import AlbumList           from './album_list';

export default class extends React.Component {
  constructor(props) {
    super(props);
    var title = props.params.id;

    this.state = {
      loading: true,
      artist:  {title: title}
    };

    $.getJSON(`http://squirrel.jaischeema.com/api/artists/${title}`, ((response) => {
      this.setState({artist: response, loading: false});
    }));
  }

  render() {
    return (
      <div className="artist">
        <div className="page-header">
          <h1>
            {this.state.artist.title}
          </h1>
        </div>
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
      return ( <AlbumList albums={this.state.artist.albums} /> );
    }
  }
}
