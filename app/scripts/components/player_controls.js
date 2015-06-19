import React from 'react';
import FormattedTime from './formatted_time';
import { PlaylistActions } from '../playlist';

export default class extends React.Component {
  render() {
    return (
      <div className="playerControls">
        {(this.props.song != null) ? this.renderPlayControls() : this.renderBlank()}
      </div>
    );
  }

  renderPlayControls() {
    var divClass = this.props.loadingSong ? "controls loading" : "controls";
    return (
      <div className={divClass}>
        <span onClick={this.onPreviousButtonClick}>Previous</span>
        <span onClick={this.onPlayButtonClick.bind(this)}>Play</span>
        <span onClick={this.onNextButtonClick}>Next</span>
        <span>{this.props.song.title}</span>
        <span>{this.props.song.artistTitle}</span>
        <span>
          <FormattedTime time={this.props.currentPosition} />
          <span>/</span>
          <FormattedTime time={this.props.totalDuration} />
        </span>
      </div>
    );
  }

  onPlayButtonClick() {
    if(this.props.paused) {
      PlaylistActions.play();
    } else {
      PlaylistActions.pause();
    }
  }

  onNextButtonClick() {
    PlaylistActions.next()
  }

  onPreviousButtonClick() {
    PlaylistActions.previous();
  }

  renderBlank() {
    return (<h3>No song loaded</h3>);
  }
}
