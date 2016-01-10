@Guest = React.createClass
  getInitialState: ->
    edit: false
  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit
  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/guests/#{@props.guest.id}"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteGuest @props.record
  handleEdit: (e) ->
    e.preventDefault()
    data =
      first_name: React.findDOMNode(@refs.first_name).value
      last_name: React.findDOMNode(@refs.last_name).value
    $.ajax
      method: 'PUT'
      url: "/guests/#{ @props.guest.id }"
      dataType: 'JSON'
      data:
        guest: data
      success: (data) =>
        @setState edit:false
      @props.handleEditGuest @props.guest, data
  guestRow: ->
    React.DOM.tr null,
      React.DOM.td null, @props.guest.first_name
      React.DOM.td null, @props.guest.last_name
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleToggle
          'Edit'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'
  guestForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.guest.first_name
          ref: 'first_name'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.guest.last_name
          ref: 'last_name'
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleEdit
          'Update'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleToggle
          'Cancel'
  render: ->
    if @state.edit
      @guestForm()
    else
      @guestRow()
