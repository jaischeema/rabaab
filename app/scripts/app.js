import React from 'react';
import { Router, Route, Link, NoMatch } from 'react-router';
import HashHistory from 'react-router/lib/HashHistory';

import Rabaab from './components/rabaab';
import LatestAlbums from './components/latest_albums';
import Album from './components/album';

class Search extends React.Component {
  render() {
    return (
      <h1>Search</h1>
    );
  }
}

React.render((
  <Router history={HashHistory}>
    <Route component={Rabaab}>
      <Route path="/" component={LatestAlbums}/>
      <Route path="/albums/:id/:title" component={Album}/>
      <Route path="/search" component={Search}/>
      <Route path="*" component={NoMatch}/>
    </Route>
  </Router>
), document.body);
