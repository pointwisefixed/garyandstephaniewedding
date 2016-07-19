@Guests = React.createClass
  getInitialState: ->
    guests: @props.data
    attending_count: @props.attending_count
  getDefaultProps: ->
    guests: []
  addGuest: (guest) ->
    guests = React.addons.update(@state.guests, { $push: [guest] })
    @setState entrees: @props.entrees
    @setState attending_count: @props.attending_count
    @setState guests: guests
  deleteGuest: (guest_id, guest_attending, guest_plusone) ->
    index = -1
    for value, i in @state.guests
      if value.id == guest_id
        index = i
        break
    attendingCount = @state.attending_count
    if guest_attending
      attendingCount = attendingCount - 1
    if guest_plusone
      attendingCount = attendingCount - 1
    guests = React.addons.update(@state.guests, { $splice: [[index, 1]]})
    @setState entrees: @props.entrees
    @setState attending_count: attendingCount
    @setState guests: guests
  updateGuest: (guest_id, data) ->
    index = -1
    for value, i in @state.guests
      if value.id == guest_id
        index = i
        break
    guests = React.addons.update(@state.guests, { $splice: [[index, 1, data]]})
    $.ajax
      method: 'GET'
      url: "/guests/count"
      dataType: 'JSON'
      success: (data) =>
        @setState attending_count: data
    @setState entrees: @props.entrees
    @setState guests: guests
  render: ->
    React.DOM.div
      className: 'guests container'
      React.DOM.h2
        className: 'title'
        'Guests'
      React.createElement GuestForm, handleNewGuest: @addGuest, entrees: @props.entrees
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'First Name'
            React.DOM.th null, 'Last Name'
            React.DOM.th null, 'Username'
            React.DOM.th null, 'Email'
            React.DOM.th null, 'RSVP?'
            React.DOM.th null, 'Plus one?'
            React.DOM.th null, 'Food Selection'
            React.DOM.th null, 'Is Admin?'
            React.DOM.th null, 'Action'
        React.DOM.tbody null,
          for guest in @state.guests
            React.createElement Guest, key: guest.id, guest: guest, entrees: @props.entrees, handleDeleteGuest: @deleteGuest, handleEditGuest: @updateGuest
          React.DOM.tr null,
            React.DOM.td null, 'Total guests attending'
            React.DOM.td null, @state.attending_count
