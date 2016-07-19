@Guest = React.createClass
  getInitialState: ->
    edit: false
    entree_id: @props.guest.entree_id
    first_name: @props.guest.first_name
    last_name: @props.guest.last_name
    attending: @props.guest.attending
    plusone: @props.guest.plusone
    admin: @props.guest.admin
    username: @props.guest.username
    email: @props.guest.email
    plus_one_entree_id: @props.guest.plus_one_entree_id
    guest_id: @props.guest.id
  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit
  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/guests/#{@state.guest_id}"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteGuest @state.guest_id, @state.attending, @state.plusone
  onDropdownChange: (c) ->
    @setState entree_id: c.newValue
  onPlusOneDropdownChange: (c) ->
    @setState plus_one_entree_id: c.newValue
  onFirstNameChange: (c) ->
    @setState first_name: c.target.value
  onLastNameChange: (c) ->
    @setState last_name: c.target.value
  onUsernameChange: (c) ->
    @setState username: c.target.value
  onAttendingChange: (c) ->
    @setState attending: c.target.checked
  onPlusoneChange: (c) ->
    @setState plusone: c.target.checked
  onEmailChange: (c) ->
    @setState email: c.target.value
  onAdminChange: (c) ->
    @setState admin: c.target.checked
  handleEdit: (e) ->
    e.preventDefault()
    data =
      first_name: @state.first_name
      last_name: @state.last_name
      username: @state.username
      email: @state.email
      attending: @state.attending
      plusone: @state.plusone
      entree_id: @state.entree_id
      plus_one_entree_id: @state.plus_one_entree_id
      id: @state.guest_id
    $.ajax
      method: 'PUT'
      url: "/guests/#{@state.guest_id}"
      dataType: 'JSON'
      data:
        guest: data
      success: (data) =>
        @setState edit:false
        @props.handleEditGuest @state.guest_id, data
  guestRow: ->
    React.DOM.tr null,
      React.DOM.td null, @state.first_name
      React.DOM.td null, @state.last_name
      React.DOM.td null, @state.username
      React.DOM.td null, @state.email
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'checkbox'
          disabled: 'disabled'
          checked: @state.attending
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'checkbox'
          disabled: 'disabled'
          checked: @state.plusone
      React.DOM.td null,
        React.createElement Dropdown, id: 'entree', disabled: 'disabled', options: @props.entrees, value: @state.entree_id, labelField: 'description', valueField: 'id'
        React.createElement Dropdown, id: 'plus_one_entree', disabled: 'disabled', options: @props.entrees, value: @state.plus_one_entree_id, labelField: 'description', valueField: 'id'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'checkbox'
          disabled: 'disabled'
          defaultChecked: @state.admin
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
          value: @state.first_name
          onChange: @onFirstNameChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          value: @state.last_name
          onChange: @onLastNameChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          value: @state.username
          onChange: @onUsernameChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          value: @state.email
          onChange: @onEmailChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'checkbox'
          checked: @state.attending
          onChange: @onAttendingChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'checkbox'
          checked: @state.plusone
          onChange: @onPlusoneChange
      React.DOM.td null,
        React.createElement Dropdown, id: 'entree_change', options: @props.entrees, value: @state.entree_id, labelField: 'description', valueField: 'id', onChange: @onDropdownChange
        React.createElement Dropdown, id: 'plus_one_entree_change', options: @props.entrees, value: @state.plus_one_entree_id, labelField: 'description', valueField: 'id', onChange: @onPlusOneDropdownChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'checkbox'
          checked: @state.admin
          onChange: @onAdminChange
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
