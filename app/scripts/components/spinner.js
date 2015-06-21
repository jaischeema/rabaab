import React from 'react';
import Spinner from 'spin';

export default class ReactSpinner extends React.Component {
  componentDidMount() {
    this.spinner = new Spinner(this.props.config);
    this.spinner.spin(this.refs.container.getDOMNode());
  }

  componentWillReceiveProps(newProps) {
    if(newProps.stopped === true && !this.props.stopped) {
      this.spinner.stop();
    } else {
      this.spinner.spin(this.refs.container.getDOMNode());
    }
  }

  componentWillUnmount() {
    this.spinner.stop();
  }

  render() {
    return (
      <span ref="container" />
    );
  }
}

ReactSpinner.propTypes = {
  config: React.PropTypes.object,
  stopped: React.PropTypes.bool
}
