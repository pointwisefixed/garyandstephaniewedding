@GuestForm = React.createClass
  getInitialState: ->
    first_name: ''
    last_name: ''
    email: ''
    password: ''
    username: ''
    can_bring_plus_one: false
    rsvp_edit_dateline: ''
    attending: false
    plusone: false
    entree_id: 0
    plus_one_entree_id: 0
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '', {guest: @state}, (data) =>
      @props.handleNewGuest data
      @setState @getInitialState()
    , 'JSON'
  handleChange: (e) ->
    name  = e.target.name
    @setState "#{ name }": e.target.value
  handleAttendingChange: (c) ->
    @setState "attending": c.target.checked
  handlePlusOneChange: (c) ->
    @setStaet "plusone": c.target.checked
  handleEntreeChange: (e) ->
    @setState "entree_id": e.newValue
  handlePlusOneEntreeChange: (e) ->
    @setState "plus_one_entree_id": e.newValue
  valid: ->
    @state.first_name && @state.last_name
  render: ->
    React.DOM.form
      className: 'form-horizontal'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'First name'
          name: 'first_name'
          value: @state.first_name
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Last name'
          className: 'form-control'
          name: 'last_name'
          value: @state.last_name
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          placeholder: 'Email'
          className: 'form-control'
          name: 'email'
          value: @state.email
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          placeholder: 'Username'
          className: 'form-control'
          name: 'username'
          value: @state.username
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          placeholder: 'password'
          className: 'form-control'
          name: 'password'
          value: @state.password
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          htmlFor: 'can_bring_plus_one'
          'Can Bring Plus one?'
        React.DOM.input
          type: 'checkbox'
          className: 'form-control'
          name: 'Can Bring Plus_one'
          value: @state.can_bring_plus_one
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          htmlFor: 'rsvp'
          'rsvp?'
        React.DOM.input
          type: 'checkbox'
          className: 'form-control'
          name: 'RSVP?'
          value: @state.attending
          onChange: @onAttendingChange
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          htmlFor: 'plus_one'
          'plus one?'
        React.DOM.input
          type: 'checkbox'
          className: 'form-control'
          name: 'Plus_one'
          value: @state.plusone
          onChange: @onPlusoneChange
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          htmlFor: 'entree_id'
          'Guest Entree'
        React.createElement Dropdown, id: 'entree_id', options: @props.entrees, value: @state.entree_id, labelField: 'description', valueField: 'id', onChange: @handleEntreeChange
      React.DOM.div
        className: 'form-group'
        React.DOM.label
          htmlFor: 'plus_one_entree_id'
          'Plus One Entree'
        React.createElement Dropdown, id: 'plus_one_entree_id', options: @props.entrees, value: @state.plus_one_entree_id, labelField: 'description', valueField: 'id', onChange: @handlePlusOneEntreeChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Add Guest'
