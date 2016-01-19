@WeddingInfo = React.createClass
  getInitialState: ->
    weddingInfo: @props.data 
  render: ->
    React.DOM.div
      className: 'weddingInfo container'
      React.DOM.h2
        className: 'title'
        'Wedding'
      React.createElement WeddingInfoForm, weddingInfo: @state.weddingInfo
      React.DOM.hr null
