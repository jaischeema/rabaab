import React from 'react';
import Spinner from './spinner';
import { Link } from 'react-router';
import { PlaylistActions } from '../playlist';
import AlbumList from './album_list';

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.search = this.search.bind(this);
    this.state  = this.stateFromProps(this.props);
    this.search();
  }

  stateFromProps(props) {
    return {
      loading: true,
      results: [],
      type:    props.location.query.type,
      query:   props.location.query.query
    };
  }

  render() {
    return (
      <div className="album">
        <div className="page-header">
          <h1>Search results</h1>
        </div>
        <div className="content">
          {this.renderContent()}
        </div>
      </div>
    );
  }

  componentWillReceiveProps(newProps) {
    this.setState(this.stateFromProps(newProps), this.search);
  }

  search() {
    $.getJSON(`http://squirrel.jaischeema.com/api/search?type=${this.state.type}&query=${this.state.query}`, ((response) => {
      this.setState({
        results: response[`${this.state.type}s`],
        loading: false
      });
    }));
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
      switch(this.state.type) {
        case "album":
          return this.renderAlbums();
        case "song":
          return this.renderSongs();
        case "artist":
          return this.renderArtists();
        default:
          return (<h1>Invalid Search type</h1>);
      }
    }
  }

  renderSongs() {
    return (<h1>Songs</h1>);
  }

  renderAlbums() {
    return (<AlbumList albums={this.state.results} />);
  }

  renderArtists() {
    return (<h1>Artists</h1>);
  }
}