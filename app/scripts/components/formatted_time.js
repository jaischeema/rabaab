import React from 'react';

export default class extends React.Component {
  render() {
    return (<span>{this.formattedText()}</span>);
  }

  formattedText() {
    if(this.props.time === undefined) {
      return "";
    }
    var time = this.props.time;
    var microsecs = time % 1000;
    time = (time - microsecs) / 1000;
    var seconds = time % 60;
    time = (time - seconds) / 60;
    var mins = time % 60;
    if(seconds > 10) {
      return `${mins}:${seconds}`;
    } else {
      return `${mins}:0${seconds}`;
    }
  }
}
