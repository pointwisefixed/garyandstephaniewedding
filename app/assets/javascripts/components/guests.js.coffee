@Guests = React.createClass
  getInitialState: ->
    guests: @props.data
  getDefaultProps: ->
    guests: []
  addGuest: (guest) ->
    guests = React.addons.update(@state.guests, { $push: [guest] })
    @setState guests: guests
  deleteGuest: (guest) ->
    index = @state.guests.indexOf guest
    guests = React.addons.update(@state.guests, { $splice: [[index, 1]]})
    @replaceState guests: guests
  updateGuest: (guest, data) ->
    index = @state.guests.indexOf guest
    guests = React.addons.update(@state.guests, { $splice: [[index, 1, data]]})
    @replaceState guests: guests
  render: ->
    React.DOM.div
      className: 'guests'
      React.DOM.h2
        className: 'title'
        'Guests'
      React.createElement GuestForm, handleNewGuest: @addGuest
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'First Name'
            React.DOM.th null, 'Last Name'
            React.DOM.th null, 'Is Admin?'
            React.DOM.th null, 'Action'
        React.DOM.tbody null,
          for guest in @state.guests
            React.createElement Guest, key: guest.id, guest: guest, handleDeleteGuest: @deleteGuest, handleEditGuest: @updateGuest
