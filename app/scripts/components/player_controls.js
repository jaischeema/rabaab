import React from 'react';
import FormattedTime from './formatted_time';
import { PlaylistActions } from '../playlist';

export default class extends React.Component {
  render() {
    return (
      <div className="player-controls">
        {(this.props.song != null) ? this.renderPlayControls() : this.renderBlank()}
      </div>
    );
  }

  renderPlayControls() {
    var divClass = this.props.loadingSong ? "controls loading" : "controls";
    return (
      <div className={divClass}>
        <div className="button col-sm-2">
          <i className="icon-control-rewind" onClick={this.onPreviousButtonClick} />
          {this.renderPlayPauseButton()}
          <i className="icon-control-forward" onClick={this.onNextButtonClick} />
        </div>
        <div className="timers col-sm-10">
          <div className="progress-bar" />
          <div className="loading-bar" />
          <div className="info">
            <span>{this.props.song.title}</span>
            <span>{this.props.song.artistTitle}</span>
          </div>
          <div className="ticker">
            <FormattedTime time={this.props.currentPosition} />
            <span>/</span>
            <FormattedTime time={this.props.totalDuration} />
          </div>
        </div>
      </div>
    );
  }

  renderPlayPauseButton() {
    var iconClass;
    if(this.props.paused) {
      iconClass = "icon-control-play play-button";
    } else {
      iconClass = "icon-control-pause play-button";
    }
    return (<i className={iconClass} onClick={this.onPlayButtonClick.bind(this)} />);
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
