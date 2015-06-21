import React from 'react';

export default class extends React.Component {
  render() {
    return (
      <div className="page-header">
        <h1>
          {this.props.title}
          {this.props.subTitle !== undefined ? (<small>{this.props.subTitle}</small>) : ''}
        </h1>
      </div>
    );
  }
}
