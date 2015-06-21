import React from 'react';

var SearchTypes = {
  a: "album",
  s: "song",
  e: "artist",
};

var SearchTypesInverse = {
  album:  "a",
  song:   "s",
  artist: "e",
};

export default class extends React.Component {
  constructor(props) {
    super(props);
    if(this.props.params !== null) {
      var type  = SearchTypesInverse[this.props.params.type];
      var query = this.props.params.query;
      if(type === undefined) {
        type = "a";
      }
      this.state = {query: `${type}:${query}`};
    } else {
      this.state = {query: ''};
    }
  }

  render() {
    return (
      <input
        className="search-bar"
        placeholder="Search for song, artist or album"
        value={this.state.query}
        onChange={this.handleChange.bind(this)}
        onKeyDown={this.onKeyDown.bind(this)}
      />
    );
  }

  onKeyDown(event) {
    if(event.which == 13) {
      var tokens = this.state.query.split(":");
      if(tokens.length > 1) {
        this.props.onSearch(tokens[1], SearchTypes[tokens[0]]);
      } else {
        this.props.onSearch(tokens[0], "album");
      }
    }
  }

  handleChange(event) {
    this.setState({query: event.target.value});
  }
}
