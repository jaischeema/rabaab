import React      from 'react';
import Spinner    from './spinner';
import AlbumList  from './album_list';
import PageHeader from './page_header';

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
        <PageHeader title={this.state.artist.title} />
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
